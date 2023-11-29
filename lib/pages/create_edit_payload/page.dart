import 'package:gap/gap.dart';

import '../../src/consts/costs.dart';
import '../../src/models/models.dart';
import '../../src/utils/utils.dart' as utils;
import '../../src/views/views.dart';
import 'controller.dart';

class CreateEditPayloadPage extends utils.Page<CreateEditPayloadController> {
  static const String name = '/create_edit_payload';

  CreateEditPayloadPage({Key? key})
      : super(controller: CreateEditPayloadController(), key: key);

  @override
  CreateEditPayloadController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text('${controller.pageData.action} Payload'),
      );

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: controller.formKey,
            onChanged: () {
              if (controller.errors.isNotEmpty) controller.errors = {};
            },
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '${controller.pageData.action} Payload',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Payload name is required";
                    }
                    return null;
                  },
                  hint: 'Name',
                ),
                TextEditView(
                  controller: controller.categoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category is required";
                    }
                    return null;
                  },
                  hint: 'Category',
                ),
                TextEditView(
                  controller: controller.descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                  hint: 'Description',
                  multiLine: true,
                  // maxHeight: 300,
                ),
                ExpandedView.label(
                  'Addresses',
                  buildBody: (context) => Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CreateAddressItemForm(onAdd: (address, price, cost) {
                        if (controller.addresses.containsKey(address)) {
                          return 'Address already exists';
                        }
                        controller.addresses[address] = PayloadAddress(
                          address,
                          price,
                          cost,
                        );
                        controller.update();
                        return null;
                      }),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: UIThemeColors.fieldBg,
                          border: Border.all(
                            width: 0.8,
                            color: UIThemeColors.field,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView(
                          primary: false,
                          children: [
                            for (PayloadAddress payloadAddress
                                in controller.addresses.values)
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: UIThemeColors.fieldBg,
                                  border: Border.all(
                                    width: 0.5,
                                    color: UIThemeColors.field,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      payloadAddress.address,
                                      style: TextStyle(
                                        color: UIThemeColors.text3,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 0.8,
                                      height: 15,
                                      color: UIThemeColors.text2,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${payloadAddress.price} DZD',
                                      style: TextStyle(
                                        color: UIThemeColors.text3,
                                      ),
                                    ),
                                    const Spacer(),
                                    OutlineButtonView.icon(
                                      Icons.delete,
                                      onPressed: () {
                                        controller.addresses.remove(
                                          payloadAddress,
                                        );
                                        controller.update();
                                      },
                                      size: 30,
                                      borderColor: Colors.transparent,
                                      iconColor: UIThemeColors.danger,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DetailsView(
                  details: controller.details,
                  // sessionsName: 'client-${controller.pageData.action}',
                  onAdd: (name, value) {
                    controller.details[name] = value;
                    controller.update();
                    return controller.details;
                  },
                  onRemove: (name) {
                    controller.details.remove(name);
                    controller.update();
                    return controller.details;
                  },
                ),
                const Gap(10),
                if (controller.pageData.action.isEdit) ...[
                  ButtonView.text(
                    backgroundColor: UIColors.warning,
                    onPressed: controller.edit,
                    text: 'Edit',
                  ),
                  ButtonView.text(
                    backgroundColor: UIThemeColors.danger,
                    onPressed: controller.delete,
                    text: 'Delete',
                  ),
                ] else
                  ButtonView.text(
                    onPressed: controller.create,
                    text: 'Create',
                  )
              ],
            ),
          ),
        ),
      );
}

class CreateAddressItemForm extends StatefulWidget {
  final String? Function(String address, double price, double cost) onAdd;

  const CreateAddressItemForm({super.key, required this.onAdd});

  @override
  State<CreateAddressItemForm> createState() => _CreateDetailsItemFormState();
}

class _CreateDetailsItemFormState extends State<CreateAddressItemForm> {
  TextEditController addressController = TextEditController(
    // name: 'address_name',
    // moreSuggestions: () async {
    //   List<String> addressSuggestions = [];
    //   if (addressSuggestions.isEmpty) {
    //     final clients = await ClientModel.all();
    //     addressSuggestions = [
    //       for (ClientModel client in clients) client.fullName,
    //       for (ClientModel client in clients)
    //         if (client.company != null) client.company!,
    //     ];
    //   }
    //   return addressSuggestions;
    // },
    text: 'Alger Port',
  );
  TextEditController priceController = TextEditController(
    // name: 'address_price'
    text: '200',
  );
  TextEditController costController = TextEditController(
    // name: 'address_cost',
    text: '200',
  );

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  addAddress() {
    if (formKey.currentState!.validate()) {
      if (widget.onAdd(
            addressController.text,
            double.parse(priceController.text),
            double.parse(costController.text),
          ) ==
          null) {
        addressController.clear();
        priceController.clear();
        costController.clear();
        formKey.currentState!.save();
      } else {
        formKey.currentState!.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: TextEditView(
                controller: addressController,
                hint: 'Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
                onSubmitted: (value) => addAddress(),
              ),
            ),
            Flexible(
              child: TextEditView(
                controller: priceController,
                hint: 'Price',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  } else if (double.tryParse(value) == null) {
                    return 'Invalid value';
                  }
                  return null;
                },
                onSubmitted: (value) => addAddress(),
              ),
            ),
            Flexible(
              child: TextEditView(
                controller: costController,
                hint: 'Cost',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cost is required';
                  } else if (double.tryParse(value) == null) {
                    return 'Invalid value';
                  }
                  return null;
                },
                onSubmitted: (value) => addAddress(),
              ),
            ),
            OutlineButtonView.icon(
              Icons.add,
              onPressed: addAddress,
              margin: const EdgeInsets.only(top: 15),
              size: 40,
            ),
          ],
        ),
      );
}
