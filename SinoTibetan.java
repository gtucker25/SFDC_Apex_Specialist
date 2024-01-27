class SinoTibetan extends Language {

    SinoTibetan(String languageName, int numberOfLangSpeakers){
      super(languageName, numberOfLangSpeakers, "Asia","subject-object-verb");
    if(languageName.contains("Chinese")){
      this.wordOrder = "subject-verb-object";
    }
    }
  }