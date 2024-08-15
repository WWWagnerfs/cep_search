import 'dart:developer';

import 'package:cep_search/models/address_model.dart';
import 'package:dio/dio.dart';
import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {

  @override
  Future<AddressModel> getCep(String cep) async {
    try {
      final result = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return AddressModel.fromMap(result.data);
    } on DioException catch (e) {
      log('Erro ao buscar cep', error: e);
      throw Exception('Erro ao buscar cep');
    }
  }
}
