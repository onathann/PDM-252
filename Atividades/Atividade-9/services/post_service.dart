// lib/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  // Base URL da API REST
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// 1. LER TODOS (GET /posts)
  /// Busca a lista completa de posts.
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('$_baseUrl/posts');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Às vezes ajuda a evitar bloqueios:
        'User-Agent': 'PostmanRuntime/7.29.0',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((jsonItem) => Post.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Erro ao buscar posts: ${response.statusCode}');
    }
  }

  /// 2. LER UM (GET /posts/{id})
  /// Busca um único post pelo seu ID.
  Future<Post> fetchPost(int id) async {
    final url = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Às vezes ajuda a evitar bloqueios:
        'User-Agent': 'PostmanRuntime/7.29.0',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(jsonMap);
    } else {
      throw Exception('Erro ao buscar o post $id: ${response.statusCode}');
    }
  }

  /// 3. CRIAR (POST /posts)
  /// Envia um novo post para o servidor.
  Future<Post> createPost(Post post) async {
    final url = Uri.parse('$_baseUrl/posts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(jsonMap);
    } else {
      throw Exception('Erro ao criar post: ${response.statusCode}');
    }
  }

  /// 4. ATUALIZAR (PUT /posts/{id})
  /// Atualiza um post existente. O objeto [post] deve conter o ID correto.
  Future<Post> updatePost(Post post) async {
    // Para atualizar, precisamos passar o ID na URL
    final url = Uri.parse('$_baseUrl/posts/${post.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(jsonMap);
    } else {
      throw Exception('Erro ao atualizar post: ${response.statusCode}');
    }
  }

  /// 5. DELETAR (DELETE /posts/{id})
  /// Remove um post do servidor pelo ID.
  Future<void> deletePost(int id) async {
    final url = Uri.parse('$_baseUrl/posts/$id');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Às vezes ajuda a evitar bloqueios:
        'User-Agent': 'PostmanRuntime/7.29.0',
      },
    );

    if (response.statusCode == 200) {
      // Sucesso na deleção (geralmente retorna vazio ou o objeto deletado)
      return;
    } else {
      throw Exception('Erro ao deletar post: ${response.statusCode}');
    }
  }
}
