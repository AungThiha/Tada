/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package tadainstaller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 *
 * @author AungThiha
 */

public class TadaInstaller {

    private static String adb;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // No. 1 give permission to adb, smali.jar and baksmali.jar if it's on unix like system
        prepareOS();
        
        pressAnyKeyToContinue();

        // No. 2 check if the device is connected
        System.out.println("Please wait! Starting adb...");
        executeADB("start-server"); // make sure not to return daemon starting blah blah blah
        boolean deviceConnected = executeADBShell("echo device").contains("error");
        if (deviceConnected) { // true if device not connected
            System.out.println("error: device not connected");
            return;
        }

        // No. 3 check if the device is rooted
        boolean isRooted = executeADBShellSu("echo rooted").contains("rooted");
        if (!isRooted) {
            System.out.println("No root access found");
            return;
        }

        // No. 4 check where TextView.java might exists.
        //Sometimes, it's in secondary-framework.
        //For example, emotion ui of huawei
        String whereTextViewLive;
        if (executeADBShellLs("system/framework/secondary-framework.jar")) {
            whereTextViewLive = "secondary-framework";
        } else {
            whereTextViewLive = "framework";
        }

        // No. 5 check it it's odex or deodex
        // if odex you need to decompile .odex file
        // if deodex you need to decompile .jar file
        boolean isOdex = executeADBShellLs("/system/framework/framework.odex");
        String dotJar = ".jar";
        String dotOdex = ".odex";
        String frameworkjar = whereTextViewLive + dotJar;
        String frameworkToDecompile;
        if (isOdex) {
            frameworkToDecompile = whereTextViewLive + dotOdex;
        } else {
            frameworkToDecompile = frameworkjar;
        }

        // No. 6 check if it's already installed
        // continue to step 6 only if not installed
        boolean isInstalled = executeADBShellLs("/system/framework/" + frameworkToDecompile + ".orig");
        if (isInstalled) {

            System.out.print("Your device is already installed Tada\nIf you want to reinstall, uninstall it first\nDo you want to uninstall? [default is Y] [Y/N] ");
            boolean uninstallYes = !System.console().readLine().trim().toLowerCase().equals("n");

            if (uninstallYes) { // so the user wants to uninstall.

                System.out.println("Please Wait! Uninstalling...");
                String localUninstallSh = "assets" + File.separator + "uninstall.sh";
                String androidUninstallSh = "/data/local/tmp/uninstall.sh";
                // push uninstall shell script to android
                executeADBPush(localUninstallSh, androidUninstallSh);
                // set the permissions on uninstallsh we have pushed to android earlier
                executeADBChmod(755, androidUninstallSh);
                // now execute that shell script to uninstall
                // you can see that frameworkToDecompile is passed as an argument to the shell script
                // it will replace $1 inside shell script when executed
                executeADBShellSu("sh " + androidUninstallSh + " " + frameworkToDecompile);
                System.out.println("Uninstallation complete\nPlease wait! Rebooting...");
                cleanAndRebootDevice();
                System.out.println("Take care!");

            }
        } else {
            // No. 6 now we're going to install
            // to know what all these does you need to know how to decompile .jar or .odex file
            // check these links if you don't know
            // http://forum.xda-developers.com/galaxy-s2/themes-apps/how-to-manually-deodex-odex-t1208320
            // http://forum.xda-developers.com/showthread.php?t=1853569
            // http://forum.xda-developers.com/showthread.php?t=1732635
            System.out.print("Do you also want to see original text? [default is Y] [Y/N] ");
            boolean addNoOriginalText = System.console().readLine().trim().toLowerCase().equals("n");
            System.out.println("Please Wait! Installing...");
            
            // clean the workspace folder
            cleanWorkspace();
            
            String tempFolder = "/data/local/tmp/";
            String workspaceFrameworkJar = "workspace" + File.separator + "system" + File.separator + "framework" + File.separator + frameworkjar;
            String classesOut = "workspace" + File.separator + "classesout";
            
            // we have already checked if it's odex or deodex at step 5
            if (isOdex) {
                // get bootclasspath
                String bootclasspath = executeADBShellSu("echo $BOOTCLASSPATH");
                String bootclasspathArr[] = bootclasspath.split(":");
                String linuxSeperator = "/";
                String destination;
                // pull the files included in bootclasspath
                // since this is the odex ROM, we need them to decompile the framework where TextView live
                for (String source : bootclasspathArr) {
                    destination = "workspace" + source.replace(linuxSeperator, File.separator);
                    executeADBPull(source, destination);
                    executeADBPull(source.replace(dotJar, dotOdex), destination.replace(dotJar, dotOdex));
                }
                // becareful, these three lines are just one statement
                String decompileOutput = decompileOdex(bootclasspath, getSdkVerstion(),
                        "workspace" + File.separator + "system" + File.separator + "framework" + File.separator + frameworkToDecompile,
                        classesOut);
                // if the decompilation output is not empty. It is an error
                if (!decompileOutput.isEmpty()) {
                    notSupported(decompileOutput);
                    return;
                }
                
                // patch TextView.smali, add Tada.smali, recompile it to jar file
                // we need this method both for odex ROM and deodex ROM
                try {
                    patch(addNoOriginalText, classesOut, workspaceFrameworkJar);
                } catch (IOException ex) {
                    notSupported(ex.getMessage());                   
                    return;
                }
                
                // we need to hack signature from the original odex file
                // to do that we need busybox and dexopt-wrapper
                String busybox = "busybox";
                String tempBusybox = tempFolder + busybox;
                String assetsBusybox = "assets" + File.separator + busybox;
                executeADBPush(assetsBusybox, tempBusybox);

                String dexoptWrapper = "dexopt-wrapper";
                executeADBPush("assets" + File.separator + dexoptWrapper, tempFolder);

                String sh = ".sh";
                String tempBusyboxSh = tempBusybox + sh;
                String assetsBusyboxSh = assetsBusybox + sh; // this is shell script to install busybox and dexopt-wrapper to system
                executeADBPush(assetsBusyboxSh, tempBusyboxSh);
                executeADBChmod(755, tempBusyboxSh);
                executeADBShellSu("sh " + tempBusyboxSh); // this command install busybox and dexopt-wrapper to the system

                cleanAndroidTemp();
                
                executeADBPush(workspaceFrameworkJar, tempFolder);
                // create odex file from jar file
                String wrapDexCmd = dexoptWrapper + " " + tempFolder + frameworkjar + " " + tempFolder + frameworkToDecompile + " " + bootclasspath.replace("/system/framework/" + frameworkjar, tempFolder + frameworkjar);
                executeADBShellSu(wrapDexCmd);
                // hack signature
                String hackSingatureCmd = busybox + " dd if=/system/framework/" + frameworkToDecompile + " of=/data/local/tmp/" + frameworkToDecompile + " bs=1 count=20 skip=52 seek=52 conv=notrunc";
                executeADBShellSu(hackSingatureCmd);
            } else {
                // for deodex ROM, we only need jar file
                executeADBPull("/system/framework/" + frameworkjar, workspaceFrameworkJar);
                
                // clean old-classes.dex that might have left
                String oldClassesDex = "workspace" + File.separator + "old-classes.dex";
                File oldClassesDexFile = new File(oldClassesDex);
                if (oldClassesDexFile.exists()) 
                    oldClassesDexFile.delete();
                
                // extract classes.dex from jar file
                try {
                    extractSingleFileZip(workspaceFrameworkJar, oldClassesDex, "classes.dex");
                } catch (IOException ex) {
                    notSupported(ex.getMessage());
                    return;
                }

                // decompile that classes.dex we extracted earlier
                String decompileOutput = decompileJar(oldClassesDex, classesOut);
                if (!decompileOutput.isEmpty()) {
                    notSupported(decompileOutput);
                    return;
                }
                
                // patch TextView.smali, add Tada.smali, recompile it to jar file
                // we use need this method both for odex ROM and deodex ROM
                try {
                    patch(addNoOriginalText, classesOut, workspaceFrameworkJar);
                } catch (IOException ex) {
                    notSupported(ex.getMessage());
                    return;
                }

                //push the jar file to android temp folder
                executeADBPush(workspaceFrameworkJar, tempFolder);
            }

            // push shell script to the device to execute
            String installSh = "install.sh";
            String localInstallSh = "assets" + File.separator + installSh;
            String androidInstallSh = tempFolder + installSh;
            executeADBPush(localInstallSh, androidInstallSh);
            executeADBChmod(755, androidInstallSh);
            // now execute that shell script to install
            // you can see that frameworkToDecompile is passed as an argument to the shell script
            // it will replace $1 inside shell script when executed
            executeADBShellSu("sh " + androidInstallSh + " " + frameworkToDecompile);
            System.out.println("Installation complete\nPlease wait! Rebooting...");
            cleanAndRebootDevice();
            System.out.println("Enjoy!");
        }
        
        pressAnyKeyToContinue();
    }

    /**
     * patch the file where TextView.smali live
     * @param addNoOriginalText do you also wanna see original text
     * @param classesOut decompiled output folder
     * @param workspaceFrameworkjar it's the framework.jar or secondary-framework.jar within workspace/system/framework
     * @return supported or not
     */
    private static void patch(boolean addNoOriginalText, String classesOut, String workspaceFrameworkjar) throws IOException {
        File assetsTadaSmali = new File("assets" + File.separator + "Tada.smali");
        String workspaceWidget = "workspace" + File.separator + "classesout" + File.separator + "android" + File.separator + "widget" + File.separator;
        File tadaSmali = new File(workspaceWidget + "Tada.smali");
        File workspaceTextView = new File(workspaceWidget + "TextView.smali");

        // check if the textview exists
        if (!workspaceTextView.exists()) {
            throw new IOException("cannot find the file to be editted");
        }

        // read Tada.smali
        String contentTadaSmali = readFile(assetsTadaSmali);
        if (addNoOriginalText) { // if the user don't like to see original text
            contentTadaSmali = contentTadaSmali.replace("const/4 v0, 0x0", "const/4 v0, 0x1");
        }

        // write Tada.smali to decompiled folder. it's just like copying.
        writeFile(contentTadaSmali, tadaSmali);
        
        // sometimes, \n doesn't work. so, we need this.
        String newline =  System.getProperty("line.separator");
        
        String contentTextViewSmali = readFile(workspaceTextView);
        String hintOrig = "invoke-static {p1}, Landroid/text/TextUtils;->stringOrSpannedString(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;" +
                newline + newline +
                "    move-result-object v0" +
                newline + newline +
                "    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;";
        String textOrig = "const/4 v0, 0x1" +
                newline + newline +
                "    const/4 v1, 0x0" +
                newline + newline +
                "    invoke-direct {p0, p1, p2, v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;Landroid/widget/TextView$BufferType;ZI)V";

        // these are what we're going to edit in TextView.smali
        // if the TextView.smali, we can't install Tada
        if (!contentTextViewSmali.contains(hintOrig) || !contentTextViewSmali.contains(textOrig)) {
            throw new IOException("cannot find the content to be editted");
        }

        // replace content of TextView.smali
        contentTextViewSmali = contentTextViewSmali.replace(hintOrig, "invoke-static {p1}, Landroid/widget/Tada;->hint(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;" +
                newline + newline +
                "    move-result-object v0" +
                newline + newline +
                "    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;" +
                newline + newline +
                "    iget-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;" +
                newline + newline +
                "    invoke-static {v0}, Landroid/text/TextUtils;->stringOrSpannedString(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;" +
                newline + newline +
                "    move-result-object v0" +
                newline + newline +
                "    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;");

        contentTextViewSmali = contentTextViewSmali.replace(textOrig, "invoke-static {p1}, Landroid/widget/Tada;->text(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;" +
                newline + newline +
                "    move-result-object p1" +
                newline + newline +
                "    const/4 v0, 0x1" +
                newline + newline +
                "    const/4 v1, 0x0" +
                newline + newline +
                "    invoke-direct {p0, p1, p2, v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;Landroid/widget/TextView$BufferType;ZI)V");
        
        // write the newly editted content to TextView.smali
        writeFile(contentTextViewSmali, workspaceTextView);

      
        String classesDex = "workspace" + File.separator + "classes.dex";
        File classesDexFile = new File(classesDex);
        if (classesDexFile.exists()) {
            classesDexFile.delete();
        }
        
        // recompile it back to classes.dex
        // even if it's odex ROM. we need to recompile it to classes.dex
        recompileJar(classesOut, classesDex);

        // add the recompile classes.dex to jar file
        // don't be confused
        // like I said. even if it's odex ROM. we need to use jar
        // if it's odex ROM, we won't add that jar to the system but we'll create odex file from that jar file
        addFileToExistingZip(new File(workspaceFrameworkjar), classesDexFile);
    }

    /**
     * write content to the file. It will be overwritten
     * @param content content to be written
     * @param file absolute file path
     * @return nothing
     */
    private static void writeFile(String content, File file) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(file, false)) {
            byte[] b = content.getBytes();
            fos.write(b);
        }
    }

    /**
     * read the whole content of the file
     * @param file absolute file path
     * @return content
     */
    private static String readFile(File file) throws IOException {
        byte[] data;
        try (FileInputStream fis = new FileInputStream(file)) {
            data = new byte[(int) file.length()];
            fis.read(data);
        }
        return new String(data, "UTF-8");
    }

    /**
     * recompile jar
     * @param source file path of your decompiled folder
     * @param destination absolute file path of where you would like to
     * recompile
     * @return output
     */
    private static String recompileJar(String source, String destination) {
        String cmd = "bin" + File.separator + "smali-2.0.5.jar " + source + " -o " + destination.toString();
        return executeJar(cmd).trim();
    }

    /**
     * recompile jar
     * @param source jar file to be decompiled
     * @param destination of decompiled jar file
     * @return output
     */
    private static String decompileJar(String source, String destination) {
        String cmd = "bin" + File.separator + "baksmali-2.0.5.jar -o " + destination + " " + source;
        return executeJar(cmd).trim();
    }

    /**
     * decompile .odex file
     * @param bootclasspath
     * @param sdkVersion
     * @param source absolute file path of odex file to be decompile
     * @param destination absolute file path of where you would like to
     * decompile
     * @return output
     */
    private static String decompileOdex(String bootclasspath, String sdkVersion, String source, String destination) {
        String cmd = "bin" + File.separator + "baksmali-2.0.5.jar -d " + bootclasspath + " -x " + source + " -a " + sdkVersion + " -o " + destination;
        return executeJar(cmd).trim();
    }

    /**
     * execute jar file
     * @param command
     * @return output
     */
    private static String executeJar(String command) {
        return executeCommand("java -Xmx512m -jar " + command);
    }

    /**
     * clean the workspace folder
     */
    private static void cleanWorkspace() {
        File file = new File("workspace" + File.separator + "system" + File.separator + "framework");
        if(file.exists())
            purgeDirectory(file);
        file = new File("workspace" + File.separator + "classesout");
        if(file.exists())
            purgeDirectory(file);
    }

    /**
     * recursive delete
     */
    private static void purgeDirectory(File dir) {
        for (File file : dir.listFiles()) {
            if (file.isDirectory()) {
                purgeDirectory(file);
            }
            file.delete();
        }
    }

    /**
     * delete all files in /data/local/tmp/ and reboot the device
     */
    private static void cleanAndRebootDevice() {
        cleanAndroidTemp();
        executeADB("reboot");
    }

    /**
     * delete all files in /data/local/tmp/
     */
    private static void cleanAndroidTemp() {
        executeADBShellSu("rm -R /data/local/tmp/*");
    }

    /**
     * get sdk version(i.e. api level) of the device
     */
    private static String getSdkVerstion() {
        return executeADBShellSu("getprop ro.build.version.sdk");
    }

    /**
     * execute shell command with root access on android
     * @param permissions to set on the file
     * @param file the absolute file path on android
     * @return nothing
     */
    private static void executeADBChmod(int permissions, String file) {
        executeADBShellSu("chmod " + permissions + " " + file);
    }

    /**
     * pull file from device
     * @param source the absolute file path of the source file
     * @param destition the absolute file path of the destination file
     * @return nothing
     */
    private static void executeADBPull(String source, String destination) {
        executeADB("pull " + source + " " + destination);
    }

    /**
     * push file to device
     * @param source the absolute file path of the source file
     * @param destition the absolute file path of the destination file
     * @return nothing
     */
    private static void executeADBPush(String source, String destination) {
        executeADB("push " + source + " " + destination);
    }

    /**
     * check if file exists on android
     * @param absoluteFilepath
     * @return exists or not
     */
    private static boolean executeADBShellLs(String absoluteFilepath) {
        return !executeADBShell("ls " + absoluteFilepath).contains("No");
    }

    /**
     * execute shell command with root access on android
     * @param command
     * @return output
     */
    private static String executeADBShellSu(String command) {
        return executeADBShell("su -c \"" + command + "\"");
    }

    /**
     * execute shell command on android
     * @param command
     * @return output
     */
    private static String executeADBShell(String command) {
        return executeADB("shell " + command);
    }

    /**
     * execute shell command on android
     * @param command
     * @return output
     */
    private static String executeADB(String command) {
        return executeCommand(adb + " " + command);
    }
    
     /**
     * tell the user that the device is not supported
     * @param additionalMessage this is the actual error Message
     */
    private static void notSupported(String additionalMessage){
       String please = "Please, kindly report the error message, your device model and android version to mr.aungthiha@gmail.com";
       additionalMessage = additionalMessage.isEmpty()? please : additionalMessage + "\n" + please;
       System.out.println(additionalMessage);
    }
    
     /**
     * nothing special. just to wait the user.
     */
    private static void pressAnyKeyToContinue(){
        System.out.print("Press any key to continue...");
        System.console().readLine();
    }

    /**
     * check OS and set permissions on binaries
     */
    private static void prepareOS() {
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            adb = "bin/adb";
            executeCommand("chmod +x bin/adb");
            executeCommand("chmod +x bin/smali-2.0.5.jar");
            executeCommand("chmod +x bin/baksmali-2.0.5.jar");
        } else {
            adb = "bin\\adb.exe";
        }
    }

    /**
     * execute shell command
     * @param command
     * @return output
     */
    private static String executeCommand(String command) {

        StringBuilder output = new StringBuilder();

        Process p;
        try {
            p = Runtime.getRuntime().exec(command);
            p.waitFor();
            BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
            if (output.toString().isEmpty()) {
                BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
                while ((line = stdError.readLine()) != null) {
                    output.append(line).append("\n");
                }
            }

        } catch (IOException | InterruptedException e) {
        }
        return output.toString();

    }

    /**
     * add file the existing zip file. it will overwrite if the versionFile is
     * already exists
     *
     * @param zipFile
     * @param versionFile file to be inserted
     * @return nothing
     */
    private static void addFileToExistingZip(File zipFile, File versionFile) throws IOException {
        // get a temp file
        File tempFile = File.createTempFile(zipFile.getName(), null);
        // delete it, otherwise you cannot rename your existing zip to it.
        tempFile.delete();

        boolean renameOk = zipFile.renameTo(tempFile);
        if (!renameOk) {
            throw new RuntimeException("could not rename the file " + zipFile.getAbsolutePath() + " to " + tempFile.getAbsolutePath());
        }
        byte[] buf = new byte[4096 * 1024];
        ZipOutputStream out;
        try (ZipInputStream zin = new ZipInputStream(new FileInputStream(tempFile))) {
            out = new ZipOutputStream(new FileOutputStream(zipFile));
            ZipEntry entry = zin.getNextEntry();
            while (entry != null) {
                String name = entry.getName();
                boolean toBeDeleted = false;
                if (versionFile.getName().indexOf(name) != -1) {
                    toBeDeleted = true;
                }
                if (!toBeDeleted) {
                    // Add ZIP entry to output stream.
                    out.putNextEntry(new ZipEntry(name));
                    // Transfer bytes from the ZIP file to the output file
                    int len;
                    while ((len = zin.read(buf)) > 0) {
                        out.write(buf, 0, len);
                    }
                }
                entry = zin.getNextEntry();
            }
        }
        try (FileInputStream in = new FileInputStream(versionFile)) {
            String fName = versionFile.getName();
            // Add ZIP entry to output stream.
            out.putNextEntry(new ZipEntry(fName));
            // Transfer bytes from the file to the ZIP file
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            // Complete the entry
            out.closeEntry();
        }
        // Complete the ZIP file
        out.close();
        tempFile.delete();
    }

    /**
     * extract single file from zip file
     *
     * @param zipFile
     * @param versionFile file to be extracted
     * @param versionFileName the name of the file to be extracted
     * @return nothing
     */
    private static void extractSingleFileZip(String zipFile, String versionFile, String versionFileName) throws IOException {
        OutputStream out = new FileOutputStream(versionFile);
        FileInputStream fin = new FileInputStream(zipFile);
        BufferedInputStream bin = new BufferedInputStream(fin);
        ZipInputStream zin = new ZipInputStream(bin);
        ZipEntry ze;
        while ((ze = zin.getNextEntry()) != null) {
            if (ze.getName().equals(versionFileName)) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = zin.read(buffer)) != -1) {
                    out.write(buffer, 0, len);
                }
                out.close();
                break;
            }
        }
    }
}
