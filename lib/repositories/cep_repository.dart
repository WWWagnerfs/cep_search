import 'package:cep_search/models/address_model.dart';

abstract class CepRepository {
  Future<AddressModel> getCep(String cep);
}