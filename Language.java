class Language {
    protected String name;
    protected int numSpeakers;
    protected String regionsSpoken;
    protected String wordOrder;
  
   Language(String inputName, int inputNumSpeakers, String inputRegionsSpoken, String inputWordOrder){
      this.name = inputName;
      this.numSpeakers = inputNumSpeakers;
      this.regionsSpoken = inputRegionsSpoken;
      this.wordOrder = inputWordOrder;
    }
  
    public void getInfo(){
      System.out.println(this.name + " is spoken by " + this.numSpeakers + " people mainly in " + this.regionsSpoken);
      System.out.println("The Language follows the word order: " + this.wordOrder);
    }
    public static void main(String[] args){
      Language Spanish = new Language("Spanish",5000000,"Spain, Latin America, South America, and Equatorial Guinea","Subject-verb-object");
      
      Mayan Kiche = new Mayan("Ki'che'",250000);
      SinoTibetan mandarinChinese = new SinoTibetan("Mandarin Chinese",5000000);
      mandarinChinese.getInfo();
      SinoTibetan Burmese = new SinoTibetan("Burmese",150000);
      Burmese.getInfo();
    }
  }