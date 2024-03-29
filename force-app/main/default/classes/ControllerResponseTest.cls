@IsTest(isParallel=true)
private class ControllerResponseTest {
	@IsTest
	private static void success_dataPasses_dataSavedInMap() {
		// Given
		String value = 'Test';

		// When
		Test.startTest();
		Map<String, Object> result = ControllerResponse.success(value);
		Test.stopTest();

		// Then
		system.assert(result.containsKey('Success'), 'Map is expected to include Success key');
		system.assert(!result.containsKey('Error'), 'Map is not expected to include Error key');
		system.assert(!result.containsKey('Warning'), 'Map is not expected to include Warning key');
		system.assertEquals('Test', (String) result.get('Success'), 'Value is expected to be stored in Map under Success key');
	}

	@IsTest
	private static void error_dataPasses_dataSavedInMap() {
		// Given
		String value = 'Test';

		// When
		Test.startTest();
		Map<String, Object> result = ControllerResponse.error(value);
		Test.stopTest();

		// Then
		system.assert(!result.containsKey('Success'), 'Map is not expected to include Success key');
		system.assert(result.containsKey('Error'), 'Map is expected to include Error key');
		system.assert(!result.containsKey('Warning'), 'Map is not expected to include Warning key');
		system.assertEquals('Test', (String) result.get('Error'), 'Value is expected to be stored in Map under Success key');
	}

	@IsTest
	private static void warning_dataPasses_dataSavedInMap() {
		// Given
		String value = 'Test';

		// When
		Test.startTest();
		Map<String, Object> result = ControllerResponse.warning(value);
		Test.stopTest();

		// Then
		system.assert(!result.containsKey('Success'), 'Map is not expected to include Success key');
		system.assert(!result.containsKey('Error'), 'Map is not expected to include Error key');
		system.assert(result.containsKey('Warning'), 'Map is expected to include Warning key');
		system.assertEquals('Test', (String) result.get('Warning'), 'Value is expected to be stored in Map under Success key');
	}
}