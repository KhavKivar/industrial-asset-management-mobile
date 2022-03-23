import 'package:flutter/cupertino.dart';

class CommonState extends ChangeNotifier{
    int selectIndex = 0;

    int actaSelectItem = 0;
    List<int> categories = [1,2,4];
    int listaFiltro= 1;
    int listaFiltroMovimientos = 0;

    int tabSelect = 0;

    void setTabSelect(int x){
      tabSelect = x;
      notifyListeners();
    }

    void setFiltroMov(int x){
      listaFiltroMovimientos=x;
      notifyListeners();
    }
    void changeSelectFiltro(int st){
      listaFiltro = st;
      notifyListeners();
    }
    void changeIndex(int newIndex){
      selectIndex = newIndex;
      notifyListeners();
    }
    void changeSelectCategories(List<int> newList){
      categories = newList;
      notifyListeners();
    }


    void changeActaIndex(int newIndex){
      actaSelectItem = newIndex;
      notifyListeners();
    }
}