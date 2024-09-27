import { LightningElement } from 'lwc';
import getMovies from '@salesforce/apex/RestMoviesCallout.getMovies'

export default class MoviesList extends LightningElement {





    handleClick(){
        let movies = []
        

        let searchKey = this.template.querySelector('lightning-input').value;
        if(searchKey.length  > 3){

            getMovies({MovieName : searchKey }).then(result=>{
                movies = JSON.parse(result);
                console.log('parse in obj--->',movies)
                
                
            })
            console.log('parse obj--->',movies.result);



        }else{




        }





    }



}