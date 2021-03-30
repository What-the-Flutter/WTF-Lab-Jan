class BackgroundImageSettingStates {
  String backGroundImagePath;

  BackgroundImageSettingStates setBackGroundImagePath(
      {String backGroundImagePath}) {
    return BackgroundImageSettingStates(
      backGroundImagePath: backGroundImagePath ?? this.backGroundImagePath,
    );
  }

  BackgroundImageSettingStates({this.backGroundImagePath});
}
