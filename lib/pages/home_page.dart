import 'dart:developer';
import 'dart:ffi';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:process_run/shell.dart';

import 'package:diff_backup/widgets/select_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  final TextEditingController _outputController =
      TextEditingController(text: 'output');
  bool _pending = false;
  List<String> _referenceFileNameList = [];
  List<String> _sourceFilePathList = [];
  int _referenceFileCount = 0;
  // 参照资源路径
  String _referencePath = '';
  // 源资源路径
  String _sourcePath = '';
  // 资源数量
  int _sourceCount = 0;
  // 需要复制文件数量
  int _totalCount = 0;
  // 处理完数量
  int _finishedCount = 0;
  String _errorMesssage = '';
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 选择参照资源路径
  void _handleSelectReferenceResourcesPath() async {
    final String? directoryPath =
        await getDirectoryPath(confirmButtonText: 'select');
    if (directoryPath != null) {
      setState(() {
        _referencePath = directoryPath;
      });
      Directory myDir = Directory(directoryPath);
      Stream<FileSystemEntity> stream = myDir.list(followLinks: false);
      var list = await stream.toList();

      setState(() {
        _referenceFileNameList = list
            .where((element) => lookupMimeType(element.path) == 'image/jpeg')
            .map((e) => basename(e.path).split('.').first)
            .toList();
        _referenceFileCount = _referenceFileNameList.length;
      });
    }
  }

  // 选择参照资源路径
  void _handleSelectSourcePath() async {
    final String? directoryPath =
        await getDirectoryPath(confirmButtonText: 'select');
    if (directoryPath != null) {
      setState(() {
        _sourcePath = directoryPath;
      });
      Directory myDir = Directory(directoryPath);
      Stream<FileSystemEntity> stream = myDir.list(followLinks: false);
      var list = await stream.toList();
      setState(() {
        _sourceFilePathList = list.map((e) => e.path).toList();
        _sourceCount = _sourceFilePathList.length;
      });
    }
  }

  // 提交
  submit(BuildContext context) => () async {
        controller.value = 0;
        setState(() {
          _errorMesssage = '';
          _pending = true;
        });

        List<String> cpList = _sourceFilePathList
            .where((e) => _referenceFileNameList
                .any((name) => basename(e).split('.').first == name))
            .toList();

        setState(() {
          _totalCount = cpList.length;
          _finishedCount = 0;
        });

        Directory parentDir = Directory(_sourcePath).parent;
        String targetPath = '${parentDir.path}/${_outputController.text}';
        try {
          Shell shell = Shell();
          // 创建文件夹
          await shell.run('mkdir -p $targetPath');
          // 开始执行shell脚本，拷贝文件
          var stream = Stream.fromFutures(
              cpList.map((element) => shell.run('cp $element $targetPath')));

          stream.listen((event) {
            setState(() {
              _finishedCount++;
              controller.value = _finishedCount / _totalCount;
            });
          }).onDone(() {
            setState(() {
              _pending = false;
            });
          });
        } catch (e) {
          setState(() {
            _errorMesssage = e.toString();
            _pending = false;
          });
        }
      };

  //  cp ${cpList.first} $targetPath
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup your Raw photo'),
      ),
      body: Center(
          child: Container(
              width: 600,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectCard(
                    title: 'Reference Directory',
                    path: _referencePath,
                    count: _referenceFileCount,
                    action: OutlinedButton(
                        onPressed: _handleSelectReferenceResourcesPath,
                        child: const Text('Select')),
                  ),
                  SelectCard(
                    title: 'Source Directory',
                    path: _sourcePath,
                    count: _sourceCount,
                    action: OutlinedButton(
                        onPressed: _handleSelectSourcePath,
                        child: const Text('Select')),
                  ),
                  TextField(
                    controller: _outputController,
                    decoration: const InputDecoration(labelText: 'Output Path'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _pending ? null : submit(context),
                        child: const Text('Start'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  LinearProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'total count: $_totalCount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                'finished count: $_finishedCount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _errorMesssage != '',
                            child: Text(
                              _errorMesssage,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ))),
    );
  }
}
