#!/bin/bash

flutter clean
flutter upgrade
flutter pub get
flutter build appbundle
