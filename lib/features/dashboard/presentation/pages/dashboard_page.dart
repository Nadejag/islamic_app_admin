import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/theme_mode_controller.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/dashboard_cubit.dart';

part 'dashboard_shell.dart';
part 'dashboard_panels.dart';
part 'dashboard_shared.dart';
part 'dashboard_media.dart';
