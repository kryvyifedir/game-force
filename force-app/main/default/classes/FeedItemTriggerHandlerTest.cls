@IsTest(isParallel=true)
private class FeedItemTriggerHandlerTest {
	@IsTest
	private static void onAfterInsert_201RecordsInserted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<FeedItem> feedItems = new List<FeedItem>();
		for (Integer i = 0; i <= 201; i++) {
			feedItems.add(TestDataFactory.initFeedItem('Published'));
		}

		// When
		Test.startTest();
		insert feedItems;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 FeedItem records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of FeedItems');
	}

	@IsTest
	private static void onAfterUpdate_201RecordsConverted_userMeasurementsCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement(Constants.CHATTER_POSTS_COUNTER_ID);
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<FeedItem> feedItems = new List<FeedItem>();
		for (Integer i = 0; i <= 201; i++) {
			feedItems.add(TestDataFactory.initFeedItem('PendingReview'));
		}
		insert feedItems;

		// When
		Test.startTest();
		for (FeedItem newFeedItem : feedItems) {
			newFeedItem.Status = 'Published';
		}
		update feedItems;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(1, result.size(), 'Single UserMeasurement__c is expected for all 201 FeedItem records');
		System.assertEquals(202, result[0].Value__c, 'Single UserMeasurement__c Value is expected to a total number of FeedItems');
	}

	@IsTest
	private static void fireEventsForNewFeedItems_measurementSetupIsMissing_userMeasurementsNotCreated(){
		// Given
		Measurement__c measurement = TestDataFactory.createMeasurement('WEIRD NAME');
		Achievement__c achievement = TestDataFactory.createAchievement('Achievement', measurement.Id);
		List<FeedItem> feedItems = new List<FeedItem>{ 
			TestDataFactory.initFeedItem('Published') 
		};

		// When
		Test.startTest();
		insert feedItems;
		Test.stopTest();

		// Then
		List<UserMeasurement__c> result = [SELECT Id, User__c, Measurement__c, Value__c FROM UserMeasurement__c];
		System.assertEquals(0, result.size(), 'Zero UserMeasurement__c is expected to be created');
	}

	@IsTest
	private static void onAfterUpdate_newMapIsNull_exceptionIsCreated(){
		// Given
		// When
		Test.startTest();
		FeedItemTriggerHandler.onAfterUpdate(null, null);
		Test.stopTest();

		// Then
		List<Log__c> result = [SELECT Id FROM Log__c];
		System.assertEquals(1, result.size(), 'Error Log is expected to be created');
	}
}