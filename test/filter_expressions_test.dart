import 'package:fitgrid_table/fitgrid_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitGridColumnFilter inList & expression parsing', () {
    test('parses in: format', () {
      final filter = FitGridColumnFilter.parse('in: Alpha, Beta', FitGridFilterKind.text);
      expect(filter, isNotNull);
      expect(filter!.operator, FitGridFilterOperator.inList);
      expect(filter.values, containsAll(<String>['Alpha', 'Beta']));
      expect(filter.matches('Alpha', null), isTrue);
      expect(filter.matches('Beta', null), isTrue);
      expect(filter.matches('Gamma', null), isFalse);
    });

    test('parses in(...) format', () {
      final filter = FitGridColumnFilter.parse('in(Alpha, Beta)', FitGridFilterKind.text);
      expect(filter, isNotNull);
      expect(filter!.operator, FitGridFilterOperator.inList);
      expect(filter.matches('Alpha', null), isTrue);
      expect(filter.matches('Beta', null), isTrue);
      expect(filter.matches('Gamma', null), isFalse);
    });

    test('toText formats inList correctly', () {
      const filter = FitGridColumnFilter(
        operator: FitGridFilterOperator.inList,
        values: <String>{'Alpha', 'Beta'},
      );
      expect(filter.toText(FitGridFilterKind.text), 'in: Alpha, Beta');
    });

    test('does not break text != or contains with or', () {
      final notEquals = FitGridColumnFilter.parse('!=apple or banana', FitGridFilterKind.text);
      expect(notEquals, isNotNull);
      expect(notEquals!.operator, FitGridFilterOperator.notEquals);
      expect(notEquals.value, 'apple or banana');

      final contains = FitGridColumnFilter.parse('apple or banana', FitGridFilterKind.text);
      expect(contains, isNotNull);
      expect(contains!.operator, FitGridFilterOperator.contains);
      expect(contains.value, 'apple or banana');
      expect(contains.matches('green apple or banana split', null), isTrue);
    });

    test('checklist filter matching remains exact and case-sensitive', () {
      const checklist = FitGridColumnFilter.oneOf(<String>{'Alpha', 'Beta'});
      expect(checklist.matches('Alpha', null), isTrue);
      expect(checklist.matches('alpha', null), isFalse);
      expect(checklist.matches('Beta', null), isTrue);
      expect(checklist.matches('beta', null), isFalse);
    });
  });
}
