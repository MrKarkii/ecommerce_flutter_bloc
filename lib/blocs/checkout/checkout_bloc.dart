import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/checkout/checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CartBloc _cartBloc;

  final CheckoutRepository _checkoutRepository;
  StreamSubscription? _cartSubscription;

  StreamSubscription? _checkoutSubscription;

  CheckoutBloc({
    required CartBloc cartBloc,
    required CheckoutRepository checkoutRepository,
  })  : _cartBloc = cartBloc,
        _checkoutRepository = checkoutRepository,
        super(
          cartBloc.state is CartLoaded
              ? CheckoutLoaded(
                  products: (cartBloc.state as CartLoaded).cart.products,
                  deliveryFee:
                      (cartBloc.state as CartLoaded).cart.deliveryFeeString,
                  subtotal: (cartBloc.state as CartLoaded).cart.subTotalString,
                  total: (cartBloc.state as CartLoaded).cart.totalString,
                )
              : CheckoutLoading(),
        ) {
    on<UpdateCheckout>(_onUpdateCheckout);
    on<ConfirmCheckout>(_onConfirmCheckout);

    _cartSubscription = _cartBloc.stream.listen(
      (state) {
        if (state is CartLoaded) {
          add(
            UpdateCheckout(cart: state.cart),
          );
        }
      },
    );
        }

    void _onUpdateCheckout(
      UpdateCheckout event,
      Emitter<CheckoutState> emit,
    ) {
      if (state is CheckoutLoaded) {
        final state = this.state as CheckoutLoaded;
        emit(
          CheckoutLoaded(
            email: event.email ?? state.email,
            fullName: event.fullName ?? state.fullName,
            products: event.cart?.products ?? state.products,
            deliveryFee: event.cart?.deliveryFeeString ?? state.deliveryFee,
            subtotal: event.cart?.subTotalString ?? state.subtotal,
            total: event.cart?.totalString ?? state.total,
            address: event.address ?? state.address,
            city: event.city ?? state.city,
            country: event.country ?? state.country,
            zipCode: event.zipCode ?? state.zipCode,
          ),
        );
      }
    }

    void _onConfirmCheckout(
      ConfirmCheckout event,
      Emitter<CheckoutState> emit,
    ) async {
      _checkoutSubscription?.cancel();
      if (state is CheckoutLoaded) {
        try {
          await _checkoutRepository.addCheckout(event.checkout);
          log('Done');
          emit(CheckoutLoading());
        } catch (_) {}
      }
    }

    @override
    Future<void> close() {
      _cartSubscription?.cancel();
      return super.close();
    }
  }
