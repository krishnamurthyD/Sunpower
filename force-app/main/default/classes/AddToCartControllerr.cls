public with sharing class AddToCartControllerr {
  @AuraEnabled(cacheable=true)
  public static String getArrayData(List<String> arrayData) {
    String result = '';
    for (String data : arrayData) {
      result += data + ', ';
    }
    result = result.removeEnd(', ');
    return result;
  }
}