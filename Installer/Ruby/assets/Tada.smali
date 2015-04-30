# This file is part of Tada
# Copyright (C) 2015-2016 Aung Thiha

# Based on paytan from Ko Thura Hlaing and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

.class public Landroid/widget/Tada;
.super Ljava/lang/Object;
.source "Tada.java"


# static fields
.field private static final ZAWGYI_DETECT_PATTERN:Ljava/util/regex/Pattern;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .prologue
    .line 29
    const-string v0, "[\u105a\u1060-\u1097]|[\u1033\u1034]|\u1031\u108f|\u1031[\u103b-\u103e]|[\u102b-\u1030\u1032]\u1031| \u1031| \u103b|^\u1031|^\u103b|\u1038\u103b|\u1038\u1031|[\u102d\u102e\u1032]\u103b|\u1039[^\u1000-\u1021]|\u1039$|\u1004\u1039[\u1001-\u102a\u103f\u104e]|\u1039[^u1000-\u102a\u103f\u104e]|\u103c\u103b|\u103d\u103b|\u103e\u103b|\u103d\u103c|\u103e\u103c|\u103e\u103d|\u103b\u103c|[\u102f\u1030\u102b\u102c][\u102d\u102e\u1032]|[\u102b\u102c][\u102f\u102c]|[\u1040-\u1049][\u102b-\u103e\u102b-\u1030\u1032\u1036\u1037\u1038\u103a]|^[\u1040\u1047][^\u1040-\u1049]|[\u1000-\u102a\u103f\u104e]\u1039[\u101a\u101b\u101d\u101f\u1022-\u103f]|\u103a\u103e|\u1036\u102b]|\u102d[\u102e\u1032]|\u102e[\u102d\u1032]|\u1032[\u102d\u102e]|\u102f\u1030|\u1030\u102f|\u102b\u102c|\u102c\u102b|[\u1090-\u1099][\u102b-\u1030\u1032\u1037\u103a-\u103e]|[\u1000-\u10f4][\u1090-\u1099][\u1000-\u104f]|^[\u1090-\u1099][\u1000-\u102a\u103f\u104e\u104a\u104b]|[\u1000-\u104f][\u1090-\u1099]$|[\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f\u109a-\u109d][\u102b-\u103e]|[\u1000-\u102a]\u103a[\u102d\u102e\u1032]|[\u102b-\u1030\u1032\u1036-\u1038\u103a]\u1031|[\u1087-\u108d][\u106e-\u1070\u1072-\u1074]|^[\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f\u109a-\u109d]|[ \u104a\u104b][\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f\u109a-\u109d]|[\u1036\u103a][\u102d-\u1030\u1032]|[\u1025\u100a]\u1039|[\u108e-\u108f][\u1050-\u108d]|\u102d-\u1030\u1032\u1036-\u1037]\u1039]|[\u1000-\u102a\u103f\u104e]\u1037\u1039|[\u1000-\u102a\u103f\u104e]\u102c\u1039[\u1000-\u102a\u103f\u104e]|[\u102b-\u1030\u1032][\u103b-\u103e]|\u1032[\u103b-\u103e]|\u101b\u103c|[\u1000-\u102a\u103f\u104e]\u1039[\u1000-\u102a\u103f\u104e]\u1039[\u1000-\u102a\u103f\u104e]|[\u1000-\u102a\u103f\u104e]\u1039[\u1000-\u102a\u103f\u104e][\u102b\u1032\u103d]|[\u1000\u1005\u100f\u1010\u1012\u1014\u1015\u1019\u101a]\u1039\u1021|[\u1000\u1010]\u1039\u1019|\u1004\u1039\u1000|\u1015\u1039[\u101a\u101e]|\u1000\u1039\u1001\u1036|\u1039\u1011\u1032|\u1037\u1032|\u1036\u103b|\u102f\u102f"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Landroid/widget/Tada;->ZAWGYI_DETECT_PATTERN:Ljava/util/regex/Pattern;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .prologue
    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static hint(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;
    .registers 2
    .param p0, "input"    # Ljava/lang/CharSequence;

    .prologue
    .line 127
    const/4 v0, 0x1

    invoke-static {p0, v0}, Landroid/widget/Tada;->zg2uni(Ljava/lang/CharSequence;Z)Ljava/lang/CharSequence;

    move-result-object v0

    return-object v0
.end method

.method public static text(Ljava/lang/CharSequence;)Ljava/lang/CharSequence;
    .registers 2
    .param p0, "input"    # Ljava/lang/CharSequence;

    .prologue
    .line 131
    const/4 v0, 0x0

    invoke-static {p0, v0}, Landroid/widget/Tada;->zg2uni(Ljava/lang/CharSequence;Z)Ljava/lang/CharSequence;

    move-result-object v0

    return-object v0
.end method

.method public static zg2uni(Ljava/lang/CharSequence;Z)Ljava/lang/CharSequence;
    .registers 8
    .param p0, "input"    # Ljava/lang/CharSequence;
    .param p1, "notAppend"    # Z

    .prologue
    .line 136
    if-nez p0, :cond_3

    .line 220
    .end local p0    # "input":Ljava/lang/CharSequence;
    :cond_2
    :goto_2
    return-object p0

    .line 139
    .restart local p0    # "input":Ljava/lang/CharSequence;
    :cond_3
    sget-object v3, Landroid/widget/Tada;->ZAWGYI_DETECT_PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v3, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v1

    .line 141
    .local v1, "matcher":Ljava/util/regex/Matcher;
    invoke-virtual {v1}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 143
    invoke-interface {p0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    .line 145
    .local v2, "output":Ljava/lang/String;
    const-string v3, "\\u106a"

    const-string/jumbo v4, "\u1009"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 146
    const-string v3, "\\u1025(?=[\\u1039\\u102c])"

    const-string/jumbo v4, "\u1009"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 147
    const-string v3, "\\u1025\\u102e"

    const-string/jumbo v4, "\u1026"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 148
    const-string v3, "\\u106b"

    const-string/jumbo v4, "\u100a"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 149
    const-string v3, "\\u1090"

    const-string/jumbo v4, "\u101b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 150
    const-string v3, "\\u1040"

    const-string/jumbo v4, "\u1040"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 151
    const-string v3, "\\u108f"

    const-string/jumbo v4, "\u1014"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 152
    const-string v3, "\\u1012"

    const-string/jumbo v4, "\u1012"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 153
    const-string v3, "\\u1013"

    const-string/jumbo v4, "\u1013"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 154
    const-string v3, "[\\u103d\\u1087]"

    const-string/jumbo v4, "\u103e"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 155
    const-string v3, "\\u103c"

    const-string/jumbo v4, "\u103d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 156
    const-string v3, "[\\u103b\\u107e\\u107f\\u1080\\u1081\\u1082\\u1083\\u1084]"

    const-string/jumbo v4, "\u103c"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 157
    const-string v3, "[\\u103a\\u107d]"

    const-string/jumbo v4, "\u103b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 158
    const-string v3, "\\u103d\\u103b"

    const-string/jumbo v4, "\u103b\u103d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 159
    const-string v3, "\\u108a"

    const-string/jumbo v4, "\u103d\u103e"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 160
    const-string v3, "\\u103e\\u103d"

    const-string/jumbo v4, "\u103d\u103e"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 161
    const-string v3, "((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u1064"

    const-string/jumbo v4, "\u1064$1$2$3"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 162
    const-string v3, "((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108b"

    const-string/jumbo v4, "\u1064$1$2$3\u102d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 163
    const-string v3, "((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108c"

    const-string/jumbo v4, "\u1064$1$2$3\u102e"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 164
    const-string v3, "((?:\\u1031)?)((?:\\u103c)?)([\\u1000-\\u1021])\\u108d"

    const-string/jumbo v4, "\u1064$1$2$3\u1036"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 165
    const-string v3, "\\u105a"

    const-string/jumbo v4, "\u102b\u103a"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 166
    const-string v3, "\\u108e"

    const-string/jumbo v4, "\u102d\u1036"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 167
    const-string v3, "\\u1033"

    const-string/jumbo v4, "\u102f"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 168
    const-string v3, "\\u1034"

    const-string/jumbo v4, "\u1030"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 169
    const-string v3, "\\u1088"

    const-string/jumbo v4, "\u103e\u102f"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 170
    const-string v3, "\\u1089"

    const-string/jumbo v4, "\u103e\u1030"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 171
    const-string v3, "\\u1039"

    const-string/jumbo v4, "\u103a"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 172
    const-string v3, "[\\u1094\\u1095]"

    const-string/jumbo v4, "\u1037"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 173
    const-string v3, "([\\u1000-\\u1021])([\\u102c\\u102d\\u102e\\u1032\\u1036]){1,2}([\\u1060\\u1061\\u1062\\u1063\\u1065\\u1066\\u1067\\u1068\\u1069\\u1070\\u1071\\u1072\\u1073\\u1074\\u1075\\u1076\\u1077\\u1078\\u1079\\u107a\\u107b\\u107c\\u1085])"

    const-string v4, "$1$3$2"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 174
    const-string v3, "\\u1064"

    const-string/jumbo v4, "\u1004\u103a\u1039"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 175
    const-string v3, "\\u104e"

    const-string/jumbo v4, "\u104e\u1004\u103a\u1038"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 176
    const-string v3, "\\u1086"

    const-string/jumbo v4, "\u103f"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 177
    const-string v3, "\\u1060"

    const-string/jumbo v4, "\u1039\u1000"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 178
    const-string v3, "\\u1061"

    const-string/jumbo v4, "\u1039\u1001"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 179
    const-string v3, "\\u1062"

    const-string/jumbo v4, "\u1039\u1002"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 180
    const-string v3, "\\u1063"

    const-string/jumbo v4, "\u1039\u1003"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 181
    const-string v3, "\\u1065"

    const-string/jumbo v4, "\u1039\u1005"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 182
    const-string v3, "[\\u1066\\u1067]"

    const-string/jumbo v4, "\u1039\u1006"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 183
    const-string v3, "\\u1068"

    const-string/jumbo v4, "\u1039\u1007"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 184
    const-string v3, "\\u1069"

    const-string/jumbo v4, "\u1039\u1008"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 185
    const-string v3, "\\u106c"

    const-string/jumbo v4, "\u1039\u100b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 186
    const-string v3, "\\u1070"

    const-string/jumbo v4, "\u1039\u100f"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 187
    const-string v3, "[\\u1071\\u1072]"

    const-string/jumbo v4, "\u1039\u1010"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 188
    const-string v3, "[\\u1073\\u1074]"

    const-string/jumbo v4, "\u1039\u1011"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 189
    const-string v3, "\\u1075"

    const-string/jumbo v4, "\u1039\u1012"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 190
    const-string v3, "\\u1076"

    const-string/jumbo v4, "\u1039\u1013"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 191
    const-string v3, "\\u1077"

    const-string/jumbo v4, "\u1039\u1014"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 192
    const-string v3, "\\u1078"

    const-string/jumbo v4, "\u1039\u1015"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 193
    const-string v3, "\\u1079"

    const-string/jumbo v4, "\u1039\u1016"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 194
    const-string v3, "\\u107a"

    const-string/jumbo v4, "\u1039\u1017"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 195
    const-string v3, "\\u107b"

    const-string/jumbo v4, "\u1039\u1018"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 196
    const-string v3, "\\u107c"

    const-string/jumbo v4, "\u1039\u1019"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 197
    const-string v3, "\\u1085"

    const-string/jumbo v4, "\u1039\u101c"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 198
    const-string v3, "\\u106d"

    const-string/jumbo v4, "\u1039\u100c"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 199
    const-string v3, "\\u1091"

    const-string/jumbo v4, "\u100f\u1039\u100d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 200
    const-string v3, "\\u1092"

    const-string/jumbo v4, "\u100b\u1039\u100c"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 201
    const-string v3, "\\u1097"

    const-string/jumbo v4, "\u100b\u1039\u100b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 202
    const-string v3, "\\u106f"

    const-string/jumbo v4, "\u100e\u1039\u100d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 203
    const-string v3, "\\u106e"

    const-string/jumbo v4, "\u100d\u1039\u100d"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 204
    const-string v3, "(\\u103c)([\\u1000-\\u1021])((?:\\u1039[\\u1000-\\u1021])?)"

    const-string v4, "$2$3$1"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 205
    const-string v3, "(\\u103d)(\\u103d)([\\u103b\\u103c])"

    const-string v4, "$3$2$1"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 206
    const-string v3, "(\\u103d)([\\u103b\\u103c])"

    const-string v4, "$2$1"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 207
    const-string v3, "(\\u103d)([\\u103b\\u103c])"

    const-string v4, "$2$1"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 208
    const-string v3, "(?<=([\\u1000-\\u101c\\u101e-\\u102a\\u102c\\u102e-\\u103d\\u104c-\\u109f\\s]))(\\u1047)"

    const-string/jumbo v4, "\u101b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 209
    const-string v3, "(\\u1047)(?=[\\u1000-\\u101c\\u101e-\\u102a\\u102c\\u102e-\\u103d\\u104c-\\u109f\\s])"

    const-string/jumbo v4, "\u101b"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 210
    const-string v3, "((?:\\u1031)?)([\\u1000-\\u1021])((?:\\u1039[\\u1000-\\u1021])?)((?:[\\u102d\\u102e\\u1032])?)([\\u1036\\u1037\\u1038]{0,2})([\\u103b-\\u103e]{0,3})((?:[\\u102f\\u1030])?)([\\u1036\\u1037\\u1038]{0,2})((?:[\\u102d\\u102e\\u1032])?)"

    const-string v4, "$2$3$6$1$4$9$7$5$8"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 211
    const-string v3, "\\u1036\\u102f"

    const-string/jumbo v4, "\u102f\u1036"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 212
    const-string v3, "(\\u103a)(\\u1037)"

    const-string v4, "$2$1"

    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 214
    if-eqz p1, :cond_275

    move-object p0, v2

    .line 215
    goto/16 :goto_2

    .line 217
    :cond_275
    const/4 v3, 0x3

    new-array v3, v3, [Ljava/lang/CharSequence;

    const/4 v4, 0x0

    aput-object v2, v3, v4

    const/4 v4, 0x1

    const-string v5, "\n\n========\n"

    aput-object v5, v3, v4

    const/4 v4, 0x2

    aput-object p0, v3, v4

    invoke-static {v3}, Landroid/text/TextUtils;->concat([Ljava/lang/CharSequence;)Ljava/lang/CharSequence;

    move-result-object v0

    .local v0, "appendOutput":Ljava/lang/CharSequence;
    move-object p0, v0

    .line 218
    goto/16 :goto_2
.end method
