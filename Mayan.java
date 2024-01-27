class Mayan extends Language {
    final String regionsSpoken = "Central America";
    final String wordOrder = "verb-object-subject";
  
    Mayan(String languageName, int speakers){
      super(languageName, speakers, "Central America", "verb-object-subject");
    }
  
    @Override
    public void getInfo(){
            System.out.println(this.name + " is spoken by " + this.numSpeakers + " people mainly in " + this.regionsSpoken);
        System.out.println("The Language follows the word order: " + this.wordOrder);
  
        System.out.println("Fun fact: " + this.name + " is an ergative language.");
      }
    }