public  class RestMoviesCallout {
    
    @AuraEnabled
    public static String getMovies(String MovieName){


        Http http = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:IMDB/imdb/imdbSearchByName?query='+MovieName);
        req.setMethod('GET');
        req.setHeader('Authorization', 'apikey 7AdIMwgKPc5NUAvvsrdBWP:7pv6PdzJ0HqHRS0iUDsO0w');
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 200){

            System.debug('response'+res.getBody());


        }




        return res.getBody();
    }
}