import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'hours_of_operation.jser.dart';

@GenSerializer(
  serializers: const [OpeningHoursDayJSONSerializer],
)
class HoursOfOperationJSONSerializer extends Serializer<HoursOfOperation>
    with _$HoursOfOperationJSONSerializer {}

class HoursOfOperation {
  HoursOfOperation({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  OpeningHoursDay monday;
  OpeningHoursDay tuesday;
  OpeningHoursDay wednesday;
  OpeningHoursDay thursday;
  OpeningHoursDay friday;
  OpeningHoursDay saturday;
  OpeningHoursDay sunday;
}

@GenSerializer()
class OpeningHoursDayJSONSerializer extends Serializer<OpeningHoursDay>
    with _$OpeningHoursDayJSONSerializer {}

class OpeningHoursDay {
  OpeningHoursDay({
    this.open,
    this.close,
  });

  String open;
  String close;
}
