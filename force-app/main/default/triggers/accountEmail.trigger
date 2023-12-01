trigger accountEmail on Account (after insert) {
        // Loop through the inserted accounts
        for (Account acc : Trigger.new) {
            // Now you can use the Account ID as needed, for example, logging it
            System.debug('New Account Created with ID: ' + acc.Id);
        }

}