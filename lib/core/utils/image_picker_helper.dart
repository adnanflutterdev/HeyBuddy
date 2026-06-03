import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/labeled_icon_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static void _pickFromCamera() async {
    final result = await ImagePicker().pickImage(source: .camera);
    if (result != null) {
      final croppedImage = await ImageCropper.platform.cropImage(
        sourcePath: result.path,
      );
      if (croppedImage != null) {
        AppNavigator.pop(File(croppedImage.path));
      }
    }
  }

  static void _pickFromGallery() async {
    final result = await ImagePicker().pickImage(
      source: .gallery,
      requestFullMetadata: true,
    );
    if (result != null) {
      final croppedImage = await ImageCropper.platform.cropImage(
        sourcePath: result.path,
      );
      if (croppedImage != null) {
        AppNavigator.pop(File(croppedImage.path));
      }
    }
  }

  static Future<File?> showSelectionImageSource(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            color: context.colors.appbar,
            padding: AppPadding.p16,
            child: const Row(
              spacing: 15,
              children: [
                LabeledIconButton(
                  onPressed: _pickFromCamera,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                ),
                LabeledIconButton(
                  onPressed: _pickFromGallery,
                  icon: Icons.folder,
                  label: 'Gallery',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
