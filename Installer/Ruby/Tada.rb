=begin
This file is part of Tada
Copyright (C) 2015-2016 Aung Thiha

Based on paytan from Ko Thura Hlaing and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
=end

require 'rbconfig'
require 'zip'
require 'fileutils'

print "Press any key to continue "
$seperator = gets
#checking OS
host_os = RbConfig::CONFIG['host_os']
if host_os == /mswin|msys|mingw|cygwin|bccwin|wince|emc/ # this is windows
  $adb = "bin\\adb.exe"
  $seperator = "\\"
else # os x or linux
  $adb = "bin/adb"
  $seperator = "/"
  system("chmod +x bin/adb")
  system("chmod +x bin/smali-2.0.5.jar")
  system("chmod +x bin/baksmali-2.0.5.jar")
end

puts "Please wait! Starting adb..."

def command(cmd)
	output = `#{$adb} #{cmd}`
end

def push(source, destination)
	command("push #{source} #{destination}")
end

def pull(source, destination)
	command("pull #{source} #{destination}")
end

def shell(cmd)
	command("shell #{cmd}")
end

def ls(absolute_file_path)
	shell("ls #{absolute_file_path}")
end

def installed?
	result = shell("ls /system/framework/#{$framework_to_patch}.orig").include?("No") ? false : true
end

def odex_rom?
	result = ls("/system/framework/framework.odex").include?("No") ? false : true
end

def su(cmd)
	shell("su -c '#{cmd}'")
end

def clean_android_temp()
	su("rm -R /data/local/tmp/*")	
end

def reboot()
	clean_android_temp()
	command("reboot")
end

def chmod(permission, absolute_file_path)
	su("chmod #{permission} #{absolute_file_path}")
end

def exec_sh(absolute_file_path, param = nil)
	cmd = "sh #{absolute_file_path}"
	cmd << " #{param}" unless param == nil
	su(cmd)
end

def emui_jelly_bean?
	output = ls("/system/framework/secondary-framework.jar").include?("No") ? false : true
end

unless shell("echo device").include? "device"
  exit
end

puts "You may need to grant permission on your device"

unless su("echo rooted").include? "rooted"
  puts "No root access found"
  exit
end

where_textview_live = "framework"
if emui_jelly_bean?
	where_textview_live = "secondary-framework"
end

jar = '.jar'
odex = '.odex' 
frameworkjar = where_textview_live + jar
temp_folder = "/data/local/tmp/"

if odex_rom?
	$odex_rom = true
	$framework_to_patch = where_textview_live + odex
else
	$odex_rom = false
	$framework_to_patch = frameworkjar
end

$assets = "assets#{$seperator}"

if installed?
	print "Your device is already installed Tada\nYou're advised to uninstall it first\nDo you want to uninstall? [default is Y] [Y/N] "
	exit if gets.chomp.upcase == 'N'	
	puts "Please Wait! Uninstalling..."
	uninstall_sh = "uninstall.sh"
	local_uninstall_sh = $assets + uninstall_sh
	android_uninstall_sh = temp_folder + uninstall_sh
	push(local_uninstall_sh, android_uninstall_sh)
    chmod(755, android_uninstall_sh)
    exec_sh(android_uninstall_sh, $framework_to_patch)
    puts "Uninstallation complete\nPlease wait! Rebooting..."
    reboot()
    puts "Take care!"
    exit
end

print "Do you also want to see original text? [default is Y] [Y/N] "
$not_append = gets.chomp.upcase  == "N" ? true : false

puts "Please wait! Installing..."

android_framework_folder = "/system/framework/"
workspace = "workspace"
$workspace_folder = workspace + $seperator
workspace_framework_folder = "#{$workspace_folder}system#{$seperator}framework#{$seperator}"
$workspace_frameworkjar = workspace_framework_folder + frameworkjar
$classes = "classes.dex"
$classesout = $workspace_folder+ "classesout"

def exec_jar(cmd)
	system("java -Xmx512m -jar #{cmd}")
end

def baksmali(input, output)
	exec_jar("bin#{$seperator}baksmali-2.0.5.jar -o #{output} #{input}")
end

def bootclasspath_backsmali(bootclasspath, sdk, input, output)
	cmd = "bin#{$seperator}baksmali-2.0.5.jar -d #{bootclasspath} -x #{input} -a #{sdk} -o #{output}"	
	exec_jar(cmd)
end

def smali(input, output)
	exec_jar("bin#{$seperator}smali-2.0.5.jar #{input} -o #{output}")
end

def sdk_version()
	result = shell("getprop ro.build.version.sdk").strip!
end

#cleaning
FileUtils.rm Dir[workspace_framework_folder + "*"]
FileUtils.rm_rf($classesout)


def not_supported
	puts "Your device cannot be installed Tada\nPlease, kindly report your device model to mr.aungthiha@gmail.com"
	exit
end

def patch()

	assets_tada_smali = "#{$assets}Tada.smali"
	workspace_widget = "#{$classesout}#{$seperator}android#{$seperator}widget#{$seperator}"
	tada_smali = workspace_widget + "Tada.smali"
	textview_smali = workspace_widget + "TextView.smali"

	not_supported() unless File.exist?(textview_smali)
		
	FileUtils.cp(assets_tada_smali, tada_smali)
	if $not_append
		tada_smali_content = File.read(tada_smali)
		tada_smali_content.gsub!("const/4 v0, 0x0", "const/4 v0, 0x1")
		File.write(tada_smali, tada_smali_content)
	end

  	
  	textview_smali_content = File.read(textview_smali)

  	hint_orig = "invoke-static {p1}, Landroid/text/TextUtils;->stringOrSpannedString(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object v0

    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;"

    text_orig = "const/4 v0, 0x1

    const/4 v1, 0x0

    invoke-direct {p0, p1, p2, v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;Landroid/widget/TextView$BufferType;ZI)V"

    not_supported() unless textview_smali_content.include?(hint_orig) && textview_smali_content.include?(text_orig)

  	textview_smali_content.gsub!(hint_orig, "invoke-static {p1}, Landroid/widget/Tada;->hint(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object v0

    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;
    
    .line 3915
    iget-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;

    invoke-static {v0}, Landroid/text/TextUtils;->stringOrSpannedString(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object v0

    iput-object v0, p0, Landroid/widget/TextView;->mHint:Ljava/lang/CharSequence;")

  	textview_smali_content.gsub!(text_orig, "invoke-static {p1}, Landroid/widget/Tada;->text(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object p1

    .line 3678
    const/4 v0, 0x1

    const/4 v1, 0x0

    invoke-direct {p0, p1, p2, v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;Landroid/widget/TextView$BufferType;ZI)V")

  	File.write(textview_smali, textview_smali_content)
  	classes_dex = $workspace_folder + $classes
  	FileUtils.rm(classes_dex) if File.exist?(classes_dex)
  	smali($classesout, classes_dex)
    Zip.continue_on_exists_proc = true
    Zip::File.open($workspace_frameworkjar) do |zip_file|
   		zip_file.add($classes, classes_dex)
   	end
end

if $odex_rom
	
	bootclasspath = su("echo $BOOTCLASSPATH").strip!

  	bootclasspath_arr = bootclasspath.split(':')
  	linux_seperator = '/'
  	bootclasspath_arr.each do |source|
  		destination = workspace + source.gsub(linux_seperator, $seperator)
    	pull(source, destination)
    	pull(source.gsub!(jar, odex), destination.gsub!(jar, odex))
  	end

  	bootclasspath_backsmali(workspace_framework_folder, sdk_version(), workspace_framework_folder + $framework_to_patch, $classesout)
  	
  	patch()

  	busybox = 'busybox'
	temp_busybox = temp_folder + busybox
	assets_busybox = $assets + busybox
	push(assets_busybox, temp_busybox)

	dexopt_wrapper = 'dexopt-wrapper'
	push($assets + dexopt_wrapper, temp_folder)

	sh = '.sh'
	temp_busybox_sh = temp_busybox + sh
	assets_busybox_sh = assets_busybox + sh
	push(assets_busybox_sh, temp_busybox_sh)
	chmod(755, temp_busybox_sh)
	exec_sh(temp_busybox_sh)

	clean_android_temp()

	push($workspace_frameworkjar, temp_folder)
	wrap_dex_cmd = "#{dexopt_wrapper} #{temp_folder}#{frameworkjar} #{temp_folder}#{$framework_to_patch} " + bootclasspath.gsub!(android_framework_folder + frameworkjar, temp_folder + frameworkjar)
	su(wrap_dex_cmd)
	hack_singature_cmd = "#{busybox} dd if=#{android_framework_folder}#{$framework_to_patch} of=#{temp_folder}#{$framework_to_patch} bs=1 count=20 skip=52 seek=52 conv=notrunc"
	su(hack_singature_cmd)
else

	pull(android_framework_folder + frameworkjar, $workspace_frameworkjar)
	
	old_classes = "#{$workspace_folder}old-#{$classes}"
	FileUtils.rm(old_classes) if File.exist?(old_classes)
	
	Zip::File.open($workspace_frameworkjar) do |zip_file|
    	entry = zip_file.glob($classes).first
    	entry.extract(old_classes)
  	end

  	baksmali(old_classes, $classesout)
  	patch()
  	push($workspace_frameworkjar, temp_folder)
end

install_sh = "install.sh"
local_install_sh = $assets +install_sh
android_install_sh = temp_folder + install_sh
push(local_install_sh, android_install_sh)
chmod(755, android_install_sh)
exec_sh(android_install_sh, $framework_to_patch)
puts "Installation complete\nPlease wait! Rebooting..."
reboot()
puts "Enjoy!"