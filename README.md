# Diff Backup

## 用于Raw照片筛选备份工具

![image](https://github.com/Eraylee/diff_backup/blob/main/screenshot/WX20220902-170123@2x.png?raw=true)

## 背景
每次拍完照片之后，需要备份 Raw 格式照片，如果把全部 Raw 格式都备份的话，太浪费硬盘空间，如果手动挑选 Raw 图片来备份，费时费力，所以想到通过程序来筛选需要备份的 Raw 文件。

所以我写出了这个程序，按照以下逻辑进行文件删选：

1. 指定一个含有修好的图片的文件夹
2. 指定一个需要备份 Raw 格式图片文件夹
3. 根据修好图片的文件名，来筛选 Raw 格式文件，将 Raw 文件记录下来
4. 利用 shell 脚本将记录的文件拷贝出来

## 支持平台
Flutter Gallery has been built to support multiple platforms. These include:

macOS 

Windows （ToDo）

## 开始使用

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

**下载**
```bash
$ git clone https://github.com/Eraylee/diff_backup.git
```
**运行**
```bash
cd diff_backup/
flutter pub get
flutter run
```