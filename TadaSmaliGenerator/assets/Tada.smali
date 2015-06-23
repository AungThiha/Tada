# This file is part of Tada
# Copyright (C) 2015-2016 Aung Thiha

# Based on on paytan from Ko Thura Hlaing, Rabbit from Ko Htain Linn Shwe and MyanmarZawgyiConverter.java from Unicode CLDR ( Common Locale Data Repository )

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
    const-string v0, 
    "%s"

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
    %s
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
