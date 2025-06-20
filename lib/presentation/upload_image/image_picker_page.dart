import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<AssetEntity> selectedImages = [];
  List<AssetEntity> galleryImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true);

      if (albums.isNotEmpty) {
        final List<AssetEntity> assets = await albums.first.getAssetListPaged(page: 0, size: 100);

        setState(() {
          galleryImages = assets;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // 권한이 없을 때 처리
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('갤러리 접근 권한 필요'),
            content: const Text('사진을 선택하려면 갤러리 접근 권한이 필요합니다.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  PhotoManager.openSetting();
                },
                child: const Text('설정으로 이동'),
              ),
            ],
          ),
    );
  }

  void toggleImageSelection(AssetEntity asset) {
    setState(() {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);
      } else {
        if (selectedImages.length < 10) {
          // 최대 10개까지 선택 가능
          selectedImages.add(asset);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('최대 10개까지 선택할 수 있습니다.')));
        }
      }
    });
  }

  void removeSelectedImage(AssetEntity asset) {
    setState(() {
      selectedImages.remove(asset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close, color: Colors.black)),
        title: const Text('그림 선택', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed:
                selectedImages.isNotEmpty
                    ? () {
                      // 선택된 이미지들을 다음 화면으로 전달
                      context.pop(selectedImages);
                    }
                    : null,
            child: Text(
              '다음',
              style: TextStyle(
                color: selectedImages.isNotEmpty ? Colors.blue : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // 선택된 이미지들을 보여주는 상단 영역
                  if (selectedImages.isNotEmpty)
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          final asset = selectedImages[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: FutureBuilder<Widget>(
                                      future: _buildImageWidget(asset, 80),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return snapshot.data!;
                                        }
                                        return Container(color: Colors.grey[200], child: const Icon(Icons.image));
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: GestureDetector(
                                    onTap: () => removeSelectedImage(asset),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  // 구분선
                  if (selectedImages.isNotEmpty)
                    Container(height: 1, color: Colors.grey[200], margin: const EdgeInsets.symmetric(horizontal: 16)),

                  // 갤러리 그리드
                  Expanded(
                    child:
                        galleryImages.isEmpty
                            ? const Center(
                              child: Text('갤러리에 이미지가 없습니다.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            )
                            : Padding(
                              padding: const EdgeInsets.all(2),
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                ),
                                itemCount: galleryImages.length,
                                itemBuilder: (context, index) {
                                  final asset = galleryImages[index];
                                  final isSelected = selectedImages.contains(asset);
                                  final selectionIndex = selectedImages.indexOf(asset) + 1;

                                  return GestureDetector(
                                    onTap: () => toggleImageSelection(asset),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: FutureBuilder<Widget>(
                                              future: _buildImageWidget(asset, 200),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return snapshot.data!;
                                                }
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                        // 선택 오버레이
                                        if (isSelected)
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: Colors.blue.withOpacity(0.3),
                                              border: Border.all(color: Colors.blue, width: 3),
                                            ),
                                          ),

                                        // 선택 번호
                                        if (isSelected)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$selectionIndex',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        // 선택되지 않은 경우 선택 버튼
                                        if (!isSelected)
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.grey, width: 1),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                  ),
                ],
              ),
    );
  }

  Future<Widget> _buildImageWidget(AssetEntity asset, double size) async {
    final thumbnail = await asset.thumbnailDataWithSize(ThumbnailSize(size.toInt(), size.toInt()));

    if (thumbnail != null) {
      return Image.memory(thumbnail, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    return Container(color: Colors.grey[200], child: const Icon(Icons.image));
  }
}
