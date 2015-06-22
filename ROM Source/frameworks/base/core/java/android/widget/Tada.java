// This file is part of Tada
// Copyright (C) 2015-2016 Aung Thiha

// Based on paytan from Ko Thura Hlaing and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

// Regular Expression for checking input text is Zawgyi or not is based on Tada's Original pattern.
// Modified it to compitable with Ethnic groups' language - Shan, Paoh, Karen- those are usable on internet.
// Added some new rules for accurency of checking.
// Credit ->  Original Authors of that part and Ko Aung Thiha.
// Contributor -> San Lin Naing

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
	static final String zawgyiRegex = "\u1031\u103b" // e+medial ra
			// beginning e or medial ra
			+ "|^\u1031|^\u103b"
			// independent vowel, dependent vowel, tone , medial ra wa ha (no ya
			// because of 103a+103b is valid in unicode) , digit ,
			// symbol + medial ra
			+ "|[\u1022-\u1030\u1032-\u1039\u103b-\u103d\u1040-\u104f]\u103b"
			// end with asat
			+ "|\u1039$"
			// medial ha + medial wa
			+ "|\u103d\u103c"
			// medial ra + medial wa
			+ "|\u103b\u103c"
			// consonant + asat + ya ra wa ha independent vowel e dot below
			// visarga asat medial ra digit symbol
			+ "|[\u1000-\u1021]\u1039[\u101a\u101b\u101d\u101f\u1022-\u102a\u1031\u1037-\u1039\u103b\u1040-\u104f]"
			// II+I II ae
			+ "|\u102e[\u102d\u103e\u1032]"
			// ae + I II
			+ "|\u1032[\u102d\u102e]"
			// I II , II I, I I, II II
			+ "|[\u102d\u102e][\u102d\u102e]"
			// U UU + U UU
			+ "|[\u102f\u1030][\u102f\u1030]"
			// tall aa short aa
			+ "|[\u102b\u102c][\u102b\u102c]"
			// shan digit + vowel
			+ "|[\u1090-\u1099][\u102b-\u1030\u1032\u1037\u103c-\u103e]"
			// consonant + medial ya + dependent vowel tone asat
			+ "|[\u1000-\u102a]\u103a[\u102c-\u102e\u1032-\u1036]"
			// independent vowel dependent vowel tone medial digit + e
			+ "|[\u1023-\u1030\u1032-\u103a\u1040-\u104f]\u1031"
			// other shapes of medial ra + consonant not in Shan consonant
			+ "|[\u107e-\u1084][\u1001\u1003\u1005-\u100f\u1012-\u1014\u1016-\u1018\u101f]"
			// u + asat
			+ "|\u1025\u1039"
			// eain-dray
			+ "|[\u1081\u1083]\u108f"
			// short na + stack characters
			+ "|\u108f[\u1060-\u108d]"
			// I II ae dow bolow above + asat typing error
			+ "|[\u102d-\u1030\u1032\u1036\u1037]\u1039"
			// aa + asat awww
			+ "|\u102c\u1039"
			// ya + medial wa
			+ "|\u101b\u103c"
			// e + zero + vowel
			+ "|\u1031?\u1040[\u102b\u105a\u102d-\u1030\u1032\u1036-\u1038]"
			// e + seven + vowel
			+ "|\u1031?\u1047[\u102c-\u1030\u1032\u1036-\u1038]";

    private static final Pattern ZAWGYI_DETECT_PATTERN = Pattern.compile(zawgyiRegex);

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
            output = output.replaceAll("\\u1088", "\u103e\u102f");
            output = output.replaceAll("\\u1089", "\u103e\u1030");
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
            output = output.replaceAll("((?:\\u1031)?)([\\u1000-\\u1021])((?:\\u1039[\\u1000-\\u1021])?)((?:[\\u102d\\u102e\\u1032])?)([\\u1036\\u1037\\u1038]{0,2})([\\u103b-\\u103e]{0,3})((?:[\\u102f\\u1030])?)([\\u1036\\u1037\\u1038]{0,2})((?:[\\u102d\\u102e\\u1032])?)", "$2$3$6$1$4$9$7$5$8");
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
