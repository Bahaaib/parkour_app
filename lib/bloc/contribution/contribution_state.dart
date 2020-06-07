import 'package:parkour_app/PODO/Contribution.dart';

abstract class ContributionState {}

class ContributionIsSubmitted extends ContributionState {}

class ContributionsAreFetched extends ContributionState {
  final List<Contribution> contributions;

  ContributionsAreFetched(this.contributions);
}
