import 'package:cart_test/models/item_carrinho.dart';

class CarrinhoDeCompras {
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => List.unmodifiable(_itens);

  void adicionarItem(ItemCarrinho item) {
    _itens.add(item);
  }

  void removerItem(String nome) {
    _itens.removeWhere((item) => item.nome == nome);
  }

  void limpar() {
    _itens.clear();
  }

  double calcularSubtotal() {
    return _itens.fold(0.0, (total, item) => total + item.subtotal);
  }

  double calcularTotalComDesconto({double percentualDesconto = 0.0}) {
    if (percentualDesconto < 0 || percentualDesconto > 100) {
      throw ArgumentError('O desconto deve estar entre 0% e 100%.');
    }

    final subtotal = calcularSubtotal();

    final desconto = subtotal * (percentualDesconto / 100);

    return subtotal - desconto;
  }

  bool temDireitoAFreteGratis() {
    return calcularSubtotal() >= 150.0;
  }
}
