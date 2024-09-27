public class TaskTriggerHandler {

    public static void checkUser(List<Task> taskList){

        Id profileId= userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        if(profileName <> 'System Administrator'){
            for(Task tsk : taskList){
                System.debug('sasda');

                tsk.addError('Please Contact your Admin as you do not have level of access');
            }
        }

    }

}