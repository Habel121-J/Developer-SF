public class  FutureExample {

@future(callout=true)
public static void FutureExample() {
    System.debug('futuremethod');


    try{

        List<Contact> conList = new List<Contact>{new Contact(LastName =  '1'),new Contact(LastName = '2')};
        insert conList;
    }Catch(Exception e){

        System.debug('exception'+e.getMessage());
    }


}
}