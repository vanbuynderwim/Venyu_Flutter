/// Enum representing prompt settings that can be configured by users
///
/// These settings correspond to the venyu_enums.prompt_setting enum in the database.
/// Each setting represents a specific configuration option for prompts.
enum PromptSetting {
  /// First Call setting - enables preview mode for prompt interactions
  firstCall('first_call'),

  /// Paused setting - pauses matching on the prompt
  paused('paused');

  const PromptSetting(this.value);

  final String value;

  /// Create PromptSetting from JSON/database value
  static PromptSetting fromJson(String value) {
    return PromptSetting.values.firstWhere(
      (setting) => setting.value == value,
      orElse: () => PromptSetting.firstCall,
    );
  }

  /// Convert PromptSetting to JSON/database value
  String toJson() => value;
}
