class OnboardinMessage {
  OnboardinMessage(this.url, this.message);

  final String url;
  final String message;
}

List<OnboardinMessage> onboardimages = [
  OnboardinMessage(
      'assets/girl.png',
      'Real-time location tracking'),
  OnboardinMessage(
      'assets/caution.png',
      'Responsive SOS button'),
  OnboardinMessage(
      'assets/group.png',
      'Create a group of close friends that can receive custom SOS alerts')
];
