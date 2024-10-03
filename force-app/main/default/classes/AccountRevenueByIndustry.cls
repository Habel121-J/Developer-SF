public class AccountRevenueByIndustry {   
    public static void  revnueByIndustry(){       
        try{        
            Map<String, Double> mapRevenue = new Map<String, Double>();
            for(Account accs: [SELECT Id, Name, Industry, AnnualRevenue FROM Account]){
                if(accs.Industry <> null && accs.AnnualRevenue <> null){
                    mapRevenue.put(accs.Industry, accs.AnnualRevenue);              
                }
            }
            System.debug('revuemaap'+mapRevenue);
            
        } catch(Exception ex){
        System.debug('Errror  '+ex.getMessage());
        }
            //return mapRevenue;
        }
}