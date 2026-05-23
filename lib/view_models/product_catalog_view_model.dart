import '../core/constants.dart';
import '../core/mvvm/base_view_model.dart';

class ProductCatalogViewModel extends BaseViewModel {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  List<String> get categories => ['All', ...AppConstants.categories];

  void selectCategory(int index) {
    if (_selectedCategoryIndex == index) {
      return;
    }
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}