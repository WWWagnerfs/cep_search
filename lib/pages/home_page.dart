import 'package:cep_search/models/address_model.dart';
import 'package:cep_search/repositories/cep_repository.dart';
import 'package:cep_search/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  AddressModel? addressModel;
  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  } // sempre que usar controler, precisa discartar a instância, para evitar excesso de consumo de memória.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          'Busca Cep',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: cepEC,
                decoration: InputDecoration(
                  labelText: 'Insira o CEP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator()),
              const SizedBox(height: 30),
              Visibility(
                  visible: addressModel != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CEP: ${addressModel?.cep}'),
                      const SizedBox(height: 5),
                      Text('Bairro: ${addressModel?.bairro}'),
                      const SizedBox(height: 5),
                      Text('Localidade: ${addressModel?.localidade}'),
                      const SizedBox(height: 5),
                      Text('Logradouro: ${addressModel?.logradouro}'),
                      const SizedBox(height: 5),
                      Text('UF: ${addressModel?.uf}'),
                      const SizedBox(height: 10),
                    ],
                  )),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final address = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        loading = false;
                        addressModel = address;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        addressModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Erro ao buscar endereço')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 50,
        color: Colors.indigo,
      ),
    );
  }
}
