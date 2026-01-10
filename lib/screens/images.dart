import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pro/pro_model.dart';
import '../providers/pro.dart';
import 'add.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProProvider>(context, listen: false).fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: Text('Picsum Photos')),
      body: Consumer<ProProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.photos.isEmpty) {
            return Center(child: Text('No photos found'));
          }
          return ListView.builder(
            itemCount: provider.photos.length,
            itemBuilder: (context, index) {
              Pro photo = provider.photos[index];
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: Image.network(
                    photo.downloadUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(photo.author ?? 'Unknown'),
                  subtitle: Text('ID: ${photo.id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Pro updated = Pro(
                            id: photo.id,
                            author: 'Updated Author',
                            width: photo.width,
                            height: photo.height,
                            url: photo.url,
                            downloadUrl: photo.downloadUrl,
                          );
                          provider.updatePhoto(photo.id!, updated);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.deletePhoto(photo.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
