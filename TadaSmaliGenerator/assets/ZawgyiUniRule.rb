module ZawgyiUniRule
	
  @rules = [
    { from: '(\u103d|\u1087)', to: '\u103e' },
    { from: '\u103c', to: '\u103d' },
    { from: '(\u103b|\u107e|\u107f|\u1080|\u1081|\u1082|\u1083|\u1084)', to: '\u103c' },
    { from: '(\u103a|\u107d)', to: '\u103b' },
    { from: '\u1039', to: '\u103a' },
    { from: '\u106a', to: '\u1009' },
    { from: '\u106b', to: '\u100a' },
    { from: '\u106c', to: '\u1039\u100b' },
    { from: '\u106d', to: '\u1039\u100c' },
    { from: '\u106e', to: '\u100d\u1039\u100d' },
    { from: '\u106f', to: '\u100d\u1039\u100e' },
    { from: '\u1070', to: '\u1039\u100f' },
    { from: '(\u1071|\u1072)', to: '\u1039\u1010' },
    { from: '\u1060', to: '\u1039\u1000' },
    { from: '\u1061', to: '\u1039\u1001' },
    { from: '\u1062', to: '\u1039\u1002' },
    { from: '\u1063', to: '\u1039\u1003' },
    { from: '\u1065', to: '\u1039\u1005' },
    { from: '\u1068', to: '\u1039\u1007' },
    { from: '\u1069', to: '\u1039\u1008' },
    { from: '/(\u1073|\u1074)/g', to: '\u1039\u1011' },
    { from: '\u1075', to: '\u1039\u1012' },
    { from: '\u1076', to: '\u1039\u1013' },
    { from: '\u1077', to: '\u1039\u1014' },
    { from: '\u1078', to: '\u1039\u1015' },
    { from: '\u1079', to: '\u1039\u1016' },
    { from: '\u107a', to: '\u1039\u1017' },
    { from: '\u107c', to: '\u1039\u1019' },
    { from: '\u1085', to: '\u1039\u101c' },
    { from: '\u1033', to: '\u102f' },
    { from: '\u1034', to: '\u1030' },
    { from: '\u103f', to: '\u1030' },
    { from: '\u1086', to: '\u103f' },
    { from: '\u1088', to: '\u103e\u102f' },
    { from: '\u1089', to: '\u103e\u1030' },
    { from: '\u108a', to: '\u103d\u103e' },
    { from: '([\u1000-\u1021])\u1064', to: '\u1004\u103a\u1039$1' },
    { from: '([\u1000-\u1021])\u108b', to: '\u1004\u103a\u1039$1\u102d' },
    { from: '([\u1000-\u1021])\u108c', to: '\u1004\u103a\u1039$1\u102e' },
    { from: '([\u1000-\u1021])\u108d', to: '\u1004\u103a\u1039$1\u1036' },
    { from: '\u108e', to: '\u102d\u1036' },
    { from: '\u108f', to: '\u1014' },
    { from: '\u1090', to: '\u101b' },
    { from: '\u1091', to: '\u100f\u1039\u1091' },
    { from: '\u1019\u102c(\u107b|\u1093)', to: '\u1019\u1039\u1018\u102c' },
    { from: '(\u107b|\u1093)', to: '\u103a\u1018' },
    { from: '(\u1094|\u1095)', to: '\u1037' },
    { from: '\u1096', to: '\u1039\u1010\u103d' },
    { from: '\u1097', to: '\u100b\u1039\u100b' },
    { from: '\u103c([\u1000-\u1021])([\u1000-\u1021])?', to: '$1\u103c$2' },
    { from: '([\u1000-\u1021])\u103c\u103a', to: '\u103c$1\u103a' },
    { from: '\u1031([\u1000-\u1021])(\u103e)?(\u103b)?', to: '$1$2$3\u1031' },
    { from: '([\u1000-\u1021])\u1031([\u103b\u103c\u103d\u103e]+)', to: '$1$2\u1031' },
    { from: '\u1032\u103d', to: '\u103d\u1032' },
    { from: '\u103d\u103b', to: '\u103b\u103d' },
    { from: '\u103a\u1037', to: '\u1037\u103a' },
    { from: '\u102f(\u102d|\u102e|\u1036|\u1037)\u102f', to: '\u102f$1' },
    { from: '\u102f\u102f', to: '\u102f' },
    { from: '(\u102f|\u1030)(\u102d|\u102e)', to: '$2$1' },
    { from: '(\u103e)(\u103b|\u1037)', to: '$2$1' },
    { from: '\u1025(\u103a|\u102c)', to: '\u1009$1' },
    { from: '\u1025\u102e', to: '\u1026' },
    { from: '\u1005\u103b', to: '\u1008' },
    { from: '\u1036(\u102f|\u1030)', to: '$1\u1036' },
    { from: '\u1031\u1037\u103e', to: '\u103e\u1031\u1037' },
    { from: '\u1031\u103e\u102c', to: '\u103e\u1031\u102c' },
    { from: '\u105a', to: '\u102b\u103a' },
    { from: '\u1031\u103b\u103e', to: '\u103b\u103e\u1031' },
    { from: '(\u102d|\u102e)(\u103d|\u103e)', to: '$2$1' },
    { from: '\u102c\u1039([\u1000-\u1021])', to: '\u1039$1\u102c' },
    { from: '\u103c\u1004\u103a\u1039([\u1000-\u1021])', to: '\u1004\u103a\u1039$1\u103c' },
    { from: '\u1039\u103c\u103a\u1039([\u1000-\u1021])', to: '\u103a\u1039$1\u103c' },
    { from: '\u103c\u1039([\u1000-\u1021])', to: '\u1039$1\u103c' },
    { from: '\u1036\u1039([\u1000-\u1021])', to: '\u1039$1\u1036' },
    { from: '\u1092', to: '\u100b\u1039\u100c' },
    { from: '\u104e', to: '\u104e\u1004\u103a\u1038' },
    { from: '\u1040(\u102b|\u102c|\u1036)', to: '\u101d$1' },
    { from: '\u1025\u1039', to: '\u1009\u1039' },
    { from: '([\u1000-\u1021])\u103c\u1031\u103d', to: '$1\u103c\u103d\u1031' },
    { from: '([\u1000-\u1021])\u103d\u1031\u103b', to: '$1\u103b\u103d\u1031' } ]

  def self.rules
    @rules
  end
end