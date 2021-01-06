

pipeline {
	agent any
		stages {
			stage('one') {
				steps {
				  echo "this is your first step in declarative pipeline"
        		              }
                        stage('two') {
				steps {
				   input('Do you want to continue?')

			             }

				  }
 			stage('three') {
			        when  {
				   not { 
			            branch "master"

			             }	
				  
			           }
                                steps {
				  
  				  echo "hello"

			           }

				}
			

                 }  

   }

}
