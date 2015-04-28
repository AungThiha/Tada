// This file is part of Tada
// Copyright (C) 2015-2016 Aung Thiha

// Based on paytan from Ko Thura Hlaing and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

package android.widget;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import android.text.TextUtils;


public class Tada {

    private static final Pattern ZAWGYI_DETECT_PATTERN = Pattern.compile(
        // A regular expression matched if text is Zawgyi encoding.
        // Using the ranges 1033-1034 or 1060-1097 will report Shan, Karen,
        // etc. as Zawgyi.
        "[\u105a\u1060-\u1097]|" // Zawgyi characters outside Unicode range
            + "[\u1033\u1034]|" // These are Mon characters
            + "\u1031\u108f|"
            + "\u1031[\u103b-\u103e]|" // Medial right after \u1031
            + "[\u102b-\u1030\u1032]\u1031|" // Vowel sign right after before \u1031
            + " \u1031| \u103b|" // Unexpected characters after a space
            + "^\u1031|^\u103b|\u1038\u103b|\u1038\u1031|"
            + "[\u102d\u102e\u1032]\u103b|\u1039[^\u1000-\u1021]|\u1039$"
            + "|\u1004\u1039[\u1001-\u102a\u103f\u104e]" // Missing ASAT in Kinzi
            + "|\u1039[^u1000-\u102a\u103f\u104e]" // 1039 not before a consonant
            // Out of order medials
            + "|\u103c\u103b|\u103d\u103b"
            + "|\u103e\u103b|\u103d\u103c"
            + "|\u103e\u103c|\u103e\u103d"
            // Bad medial combos
            + "|\u103b\u103c"
            // Out of order vowel signs
            + "|[\u102f\u1030\u102b\u102c][\u102d\u102e\u1032]"
            + "|[\u102b\u102c][\u102f\u102c]"
            // Digit before diacritic
            + "|[\u1040-\u1049][\u102b-\u103e\u102b-\u1030\u1032\u1036\u1037\u1038\u103a]"
            // Single digit 0, 7 at start
            + "|^[\u1040\u1047][^\u1040-\u1049]"
            // Second 1039 with bad followers
            + "|[\u1000-\u102a\u103f\u104e]\u1039[\u101a\u101b\u101d\u101f\u1022-\u103f]"
            // Other bad combos.
            + "|\u103a\u103e"
            + "|\u1036\u102b]"
            // multiple upper vowels
            + "|\u102d[\u102e\u1032]|\u102e[\u102d\u1032]|\u1032[\u102d\u102e]"
            // Multiple lower vowels
            + "|\u102f\u1030|\u1030\u102f"
            // Multiple A vowels
            + "|\u102b\u102c|\u102c\u102b"
            // Shan digits with vowels or medials or other signs
            + "|[\u1090-\u1099][\u102b-\u1030\u1032\u1037\u103a-\u103e]"
            // Isolated Shan digit
            + "|[\u1000-\u10f4][\u1090-\u1099][\u1000-\u104f]"
            + "|^[\u1090-\u1099][\u1000-\u102a\u103f\u104e\u104a\u104b]"
            + "|[\u1000-\u104f][\u1090-\u1099]$"
            // Diacritics with non-Burmese vowel signs
            + "|[\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d"
            + "\u108f\u109a-\u109d]"
            + "[\u102b-\u103e]"
            // Consonant 103a + some vowel signs
            + "|[\u1000-\u102a]\u103a[\u102d\u102e\u1032]"
            // 1031 after other vowel signs
            + "|[\u102b-\u1030\u1032\u1036-\u1038\u103a]\u1031"
            // Using Shan combining characters with other languages.
            + "|[\u1087-\u108d][\u106e-\u1070\u1072-\u1074]"
            // Non-Burmese diacritics at start, following space, or following sections
            + "|^[\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074"
            + "\u1082-\u108d\u108f\u109a-\u109d]"
            + "|[\u0020\u104a\u104b][\u105e-\u1060\u1062-\u1064\u1067-\u106d"
            + "\u1071-\u1074\u1082-\u108d\u108f\u109a-\u109d]"
            // Wrong order with 1036
            + "|[\u1036\u103a][\u102d-\u1030\u1032]"
            // Odd stacking
            + "|[\u1025\u100a]\u1039"
            // More mixing of non-Burmese languages
            + "|[\u108e-\u108f][\u1050-\u108d]"
            // Bad diacritic combos.
            + "|\u102d-\u1030\u1032\u1036-\u1037]\u1039]"
            // Dot before subscripted consonant
            + "|[\u1000-\u102a\u103f\u104e]\u1037\u1039"
            // Odd subscript + vowel signs
            + "|[\u1000-\u102a\u103f\u104e]\u102c\u1039[\u1000-\u102a\u103f\u104e]"
            // Medials after vowels
            + "|[\u102b-\u1030\u1032][\u103b-\u103e]"
            // Medials
            + "|\u1032[\u103b-\u103e]"
            // Medial with 101b
            + "|\u101b\u103c"
            // Stacking too deeply: consonant 1039 consonant 1039 consonant
            + "|[\u1000-\u102a\u103f\u104e]\u1039[\u1000-\u102a\u103f\u104e]\u1039"
            + "[\u1000-\u102a\u103f\u104e]"
            // Stacking pattern consonant 1039 consonant 103a other vowel signs
            + "|[\u1000-\u102a\u103f\u104e]\u1039[\u1000-\u102a\u103f\u104e]"
            + "[\u102b\u1032\u103d]"
            // Odd stacking over u1021, u1019, and u1000
            + "|[\u1000\u1005\u100f\u1010\u1012\u1014\u1015\u1019\u101a]\u1039\u1021"
            + "|[\u1000\u1010]\u1039\u1019"
            + "|\u1004\u1039\u1000"
            + "|\u1015\u1039[\u101a\u101e]"
            + "|\u1000\u1039\u1001\u1036"
            + "|\u1039\u1011\u1032"
            // Vowel sign in wrong order
            + "|\u1037\u1032"
            + "|\u1036\u103b"
            // Duplicated vowel
            + "|\u102f\u102f"
        );

	public static CharSequence hint(CharSequence input){
		return zg2uni(input, true); // true means not append the original text
	}

	public static CharSequence text(CharSequence input) {
		return zg2uni(input, false); // false means will append the original text      
    }

    public static CharSequence zg2uni(CharSequence input, boolean notAppend) {

    	if(input == null) 
            return input;

        Matcher matcher = ZAWGYI_DETECT_PATTERN.matcher(input);
        
        if(matcher.find()){

        	String output = input.toString();

        	output = output.replaceAll("\\u106a", "\u1009");
        	output = output.replaceAll("\\u1025(?=[\\u1039\\u102c])", "\u1009");
        	output = output.replaceAll("\\u1025\\u102e", "\u1026");
        	output = output.replaceAll("\\u106b", "\u100a");
        	output = output.replaceAll("\\u1090", "\u101b");
        	output = output.replaceAll("\\u1040", "\u1040");
        	output = output.replaceAll("\\u108f", "\u1014");
        	output = output.replaceAll("\\u1012", "\u1012");
        	output = output.replaceAll("\\u1013", "\u1013");
        	output = output.replaceAll("[\\u103d\\u1087]", "\u103e");
        	output = output.replaceAll("\\u103c", "\u103d");
        	output = output.replaceAll("[\\u103b\\u107e\\u107f\\u1080\\u1081\\u1082\\u1083\\u1084]", "\u103c");
        	output = output.replaceAll("[\\u103a\\u107d]", "\u103b");
        	output = output.replaceAll("\\u103d\\u103b", "\u103b\u103d");
        	output = output.replaceAll("\\u108a","\u103d\u103e");
        	output = output.replaceAll("\\u103e\\u103d", "\u103d\u103e");
        	output = output.replaceAll("((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u1064", "\u1064$1$2$3");
        	output = output.replaceAll("((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108b", "\u1064$1$2$3\u102d");
        	output = output.replaceAll("((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108c", "\u1064$1$2$3\u102e");
        	output = output.replaceAll("((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108d", "\u1064$1$2$3\u1036");
        	output = output.replaceAll("\\u105a", "\u102b\u103a");
        	output = output.replaceAll("\\u108e", "\u102d\u1036");
        	output = output.replaceAll("\\u1033", "\u102f");
        	output = output.replaceAll("\\u1034", "\u1030");
        	output = output.replaceAll("\\u1088", "\u103d\u102f");
        	output = output.replaceAll("\\u1089", "\u103d\u1030");
        	output = output.replaceAll("\\u1039", "\u103a");
        	output = output.replaceAll("[\\u1094\\u1095]", "\u1037");
        	output = output.replaceAll("([\\u1000-\\u1021])([\\u102c\\u102d\\u102e\\u1032\\u1036]){1,2}([\\u1060\\u1061\\u1062\\u1063\\u1065\\u1066\\u1067\\u1068\\u1069\\u1070\\u1071\\u1072\\u1073\\u1074\\u1075\\u1076\\u1077\\u1078\\u1079\\u107a\\u107b\\u107c\\u1085])", "$1$3$2");
        	output = output.replaceAll("\\u1064", "\u1004\u103a\u1039");
        	output = output.replaceAll("\\u104e", "\u104e\u1004\u103a\u1038");
        	output = output.replaceAll("\\u1086", "\u103f");
        	output = output.replaceAll("\\u1060", "\u1039\u1000");
        	output = output.replaceAll("\\u1061", "\u1039\u1001");
        	output = output.replaceAll("\\u1062", "\u1039\u1002");
        	output = output.replaceAll("\\u1063", "\u1039\u1003");
        	output = output.replaceAll("\\u1065", "\u1039\u1005");
        	output = output.replaceAll("[\\u1066\\u1067]", "\u1039\u1006");
        	output = output.replaceAll("\\u1068", "\u1039\u1007");
        	output = output.replaceAll("\\u1069", "\u1039\u1008");
        	output = output.replaceAll("\\u106c", "\u1039\u100b");
        	output = output.replaceAll("\\u1070", "\u1039\u100f");
        	output = output.replaceAll("[\\u1071\\u1072]", "\u1039\u1010");
        	output = output.replaceAll("[\\u1073\\u1074]", "\u1039\u1011");
        	output = output.replaceAll("\\u1075", "\u1039\u1012");
        	output = output.replaceAll("\\u1076", "\u1039\u1013");
        	output = output.replaceAll("\\u1077", "\u1039\u1014");
        	output = output.replaceAll("\\u1078", "\u1039\u1015");
        	output = output.replaceAll("\\u1079", "\u1039\u1016");
        	output = output.replaceAll("\\u107a", "\u1039\u1017");
        	output = output.replaceAll("\\u107b", "\u1039\u1018");
        	output = output.replaceAll("\\u107c", "\u1039\u1019");
        	output = output.replaceAll("\\u1085", "\u1039\u101c");
        	output = output.replaceAll("\\u106d", "\u1039\u100c");
        	output = output.replaceAll("\\u1091", "\u100f\u1039\u100d");
        	output = output.replaceAll("\\u1092", "\u100b\u1039\u100c");
        	output = output.replaceAll("\\u1097", "\u100b\u1039\u100b");
        	output = output.replaceAll("\\u106f", "\u100e\u1039\u100d");
        	output = output.replaceAll("\\u106e", "\u100d\u1039\u100d");
        	output = output.replaceAll("(\\u103c)([\\u1000-\\u1021])((?:\\u1039[\\u1000-\\u1021])?)", "$2$3$1");
        	output = output.replaceAll("(\\u103d)(\\u103d)([\\u103b\\u103c])", "$3$2$1");
        	output = output.replaceAll("(\\u103d)([\\u103b\\u103c])", "$2$1");
        	output = output.replaceAll("(\\u103d)([\\u103b\\u103c])", "$2$1");
        	output = output.replaceAll("(?<=([\\u1000-\\u101c\\u101e-\\u102a\\u102c\\u102e-\\u103d\\u104c-\\u109f\\s]))(\\u1047)", "\u101b");
        	output = output.replaceAll("(\\u1047)(?=[\\u1000-\\u101c\\u101e-\\u102a\\u102c\\u102e-\\u103d\\u104c-\\u109f\\s])", "\u101b");
        	output = output.replaceAll("((?:\\u1031)?)([\\u1000-\\u1021])((?:\\u1039[\\u1000-\\u1021])?)((?:[\\u102d\\u102e\\u1032])?)([\\u1036\\u1037\\u1038]{0,2})([\\u103b-\\u103d]{0,3})((?:[\\u102f\\u1030])?)([\\u1036\\u1037\\u1038]{0,2})((?:[\\u102d\\u102e\\u1032])?)", "$2$3$6$1$4$9$7$5$8");
        	output = output.replaceAll("\\u1036\\u102f", "\u102f\u1036");
        	output = output.replaceAll("(\\u103a)(\\u1037)", "$2$1");

        	if(notAppend)
        		return output;

        	CharSequence appendOutput = TextUtils.concat(output, "========", input);
        	return appendOutput;
    	}else{
    		return input;
    	}	

    }

}
