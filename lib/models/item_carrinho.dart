class ItemCarrinho {
  final String nome;
  final double preco;
  final int quantidade;
 
  ItemCarrinho({required this.nome, required this.preco, this.quantidade = 1}) {
    if (preco < 0) {
      throw ArgumentError('O preço do item não pode ser negativo.');
    }
 
    if (quantidade <= 0) {
      throw ArgumentError('A quantidade deve ser maior que zero.');
    }
  }
 
  double get subtotal => preco * quantidade;
}