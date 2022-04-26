import 'dart:convert';

import 'package:http/http.dart';

import 'cliente.dart';

class EditCliente {
  Cliente cliente;
  String oldRut;
  String newRut;
  EditCliente({
    required this.cliente,
    required this.oldRut,
    required this.newRut,
  });

  EditCliente copyWith({
    Cliente? cliente,
    String? oldRut,
    String? newRut,
  }) {
    return EditCliente(
      cliente: cliente ?? this.cliente,
      oldRut: oldRut ?? this.oldRut,
      newRut: newRut ?? this.newRut,
    );
  }

  factory EditCliente.fromMap(Map<String, dynamic> map) {
    return EditCliente(
      cliente: Cliente.fromJson(map['cliente']),
      oldRut: map['oldRut'] ?? '',
      newRut: map['newRut'] ?? '',
    );
  }

  factory EditCliente.fromJson(Map<String, dynamic> source) =>
      EditCliente.fromMap(source);

  @override
  String toString() =>
      'EditCliente(cliente: $cliente, oldRut: $oldRut, newRut: $newRut)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditCliente &&
        other.cliente == cliente &&
        other.oldRut == oldRut &&
        other.newRut == newRut;
  }

  @override
  int get hashCode => cliente.hashCode ^ oldRut.hashCode ^ newRut.hashCode;
}
