import 'package:dartz/dartz.dart';
import 'package:smart_parking/domain/core/failures.dart';
import 'package:smart_parking/domain/core/value_objects.dart';
import 'package:smart_parking/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);
}

class PasswordConfirmation extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory PasswordConfirmation({
    required String source,
    required String compare,
  }) {
    return PasswordConfirmation._(
      validateSameValue(source: source, compare: compare)
          .flatMap(validatePassword),
    );
  }

  const PasswordConfirmation._(this.value);
}

class Phone extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Phone(String input) {
    return Phone._(
      validateStringNotEmpty(input).flatMap(validateSingleLine),
    );
  }

  const Phone._(this.value);
}

class Address extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Address(String input) {
    return Address._(
      validateStringNotEmpty(input),
    );
  }

  const Address._(this.value);
}

class Fullname extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Fullname(String input) {
    return Fullname._(
      validateStringNotEmpty(input).flatMap(validateSingleLine),
    );
  }

  const Fullname._(this.value);
}
