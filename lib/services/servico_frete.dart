class ServicoFrete {
  /// Simula uma chamada assíncrona para uma API ou serviço externo de frete (ex: Correios).
  Future<double> calcularFrete(String cep) async {
    // Simula a latência de rede
    await Future.delayed(const Duration(milliseconds: 300));

    final cepNumeros = cep.replaceAll(RegExp(r'\D'), '');
    if (cepNumeros.length != 8) {
      throw ArgumentError('CEP inválido. Deve conter 8 dígitos.');
    }

    // Retorna um valor base simulado
    return 20.0;
  }
}
