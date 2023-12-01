public with sharing class StudentDetails {

    @AuraEnabled(cacheable=true)

    public static List<Student__c> getStudent(String strStudentName) {

      String strKey = '%'+strStudentName+'%';

       List<Student__c> stdList = [SELECT Id,Name,RollNumber__c FROM Student__c WHERE name like :strKey ];

       return stdList;

    }

}