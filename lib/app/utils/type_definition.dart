import 'package:dartz/dartz.dart';
import 'package:shoe_care/data/models/mitra_rekening_mode.dart';
import 'package:shoe_care/data/models/mitra_service_model.dart';
import 'package:shoe_care/data/models/user_profile_model.dart';
import '../../data/models/mitra_models.dart';
import '../../data/models/transaction_detail_model.dart';
import '../../data/models/transaction_models.dart';
import 'failure.dart';

typedef StringOrFailure = Either<Failure, String>;
typedef ProfileOrFailure = Either<Failure, UserProfile>;

typedef ListMitraOrFailure = Either<Failure, List<Mitra>>;
typedef MitraOrFailure = Either<Failure, Mitra>;
typedef MitraRekeningOrFailure = Either<Failure, MitraRekening>;
typedef MitraRekeningListOrFailure = Either<Failure, List<MitraRekening>>;
typedef MitraServiceOrFailure = Either<Failure, MitraService>;
typedef MitraServiceListOrFailure = Either<Failure, List<MitraService>>;

typedef TransactionOrFailure = Either<Failure, Transaction>;
typedef TransactionsOrFailure = Either<Failure, List<Transaction>>;
typedef TransactionDetailOrFailure = Either<Failure, TransactionDetail>;
