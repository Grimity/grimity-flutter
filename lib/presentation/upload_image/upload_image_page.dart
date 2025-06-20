import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/presentation/common/widget/grimity_underline_text_field.dart';
import 'package:grimity/presentation/upload_image/image_picker_page.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final TextEditingController _titleController = TextEditingController();
  List<AssetEntity> selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _openImagePicker() async {
    final result = await Navigator.of(
      context,
    ).push<List<AssetEntity>>(MaterialPageRoute(builder: (context) => const ImagePickerPage()));

    if (result != null) {
      setState(() {
        selectedImages = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close, color: Colors.black)),
        title: const Text('새 게시물', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed:
                selectedImages.isNotEmpty && _titleController.text.isNotEmpty
                    ? () {
                      // 게시물 업로드 로직
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('게시물이 업로드되었습니다!')));
                      context.pop();
                    }
                    : null,
            child: Text(
              '공유',
              style: TextStyle(
                color: selectedImages.isNotEmpty && _titleController.text.isNotEmpty ? Colors.blue : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 제목 입력 필드
            GrimityUnderlineTextField.normal(controller: _titleController, hintText: '제목을 입력하세요'),

            const SizedBox(height: 20),

            // 선택된 이미지들 미리보기
            if (selectedImages.isNotEmpty) ...[
              const Text('선택된 이미지', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    final asset = selectedImages[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FutureBuilder<Widget>(
                          future: _buildImageWidget(asset),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            }
                            return Container(color: Colors.grey[200], child: const Icon(Icons.image));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 이미지 선택 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openImagePicker,
                icon: const Icon(Icons.photo_library),
                label: Text(selectedImages.isEmpty ? '사진 선택' : '사진 변경'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 선택된 이미지 개수 표시
            if (selectedImages.isNotEmpty)
              Text('${selectedImages.length}개의 이미지가 선택되었습니다.', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildImageWidget(AssetEntity asset) async {
    final thumbnail = await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200));

    if (thumbnail != null) {
      return Image.memory(thumbnail, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    return Container(color: Colors.grey[200], child: const Icon(Icons.image));
  }
}
