import 'package:gap/gap.dart';

import '../../src/src.dart';
import 'controller.dart';

class LoadingPage extends MPage<LoadingController> {
  static const String name = '/loading';

  LoadingPage({Key? key}) : super(controller: LoadingController(), key: key);

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            Consts.logo1,
            width: 150,
            height: 150,
          ),
          const Gap(10),
          Text(
            Consts.appName,
            style: TextStyle(color: UIThemeColors.text1, fontSize: 24),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CircularProgressIndicator(
              color: UIThemeColors.primary,
            ),
          ),
          const Spacer(),
        ],
      );
}
