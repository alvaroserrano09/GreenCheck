import 'package:green_check/domain/models/answer.dart';
import 'package:green_check/domain/models/course.dart';
import 'package:green_check/domain/models/notice.dart';
import 'package:green_check/domain/models/question.dart';
import 'package:green_check/domain/models/result.dart';
import 'package:green_check/domain/models/test.dart';
import 'package:green_check/domain/models/user.dart';

class InfoObjectMother {
  static createCourse() {
    return Course(
      id: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
      name: 'Oposiciones de la Junta de Andalucía',
      description:
          'Curso de preparación para oposiciones de la Junta de Andalucía',
      idTeacher: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      type: 'Oposicion',
    );
  }

  static createCourse1() {
    return Course(
      id: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
      name: 'Curso de Programación Avanzada',
      description: 'Curso avanzado de programación en Dart y Flutter',
      idTeacher: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      type: 'Curso',
    );
  }

  static createCourse2() {
    return Course(
      id: '0e7b8d65-37a1-4c2a-babb-35d5db592e8d',
      name: 'Oposicion Policia Nacional',
      description:
          'Curso de preparación para oposiciones de la Policía Nacional',
      idTeacher: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      type: 'Oposicion',
    );
  }

  static createTeacher() {
    return User(
      email: 'alvaro@gmail.com',
      id: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      name: 'Álvaro',
      role: 'teacher',
      surname: 'Gómez',
    );
  }

  static createResult() {
    return Result(
      id: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
      dateFinished: DateTime.now(),
      score: 10,
      idStudent: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      idTest: '0e7b8d65-37a1-4c2a-babb-35d5db592e8d',
    );
  }

  static createResult1() {
    return Result(
      id: 'abcd1234-5678-90ab-cdef-1234567890ab',
      dateFinished: DateTime.now(),
      score: 15,
      idStudent: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      idTest: '0e7b8d65-37a1-4c2a-babb-35d5db592e8d',
    );
  }

  static createTest() {
    return Test(
      id: '0e7b8d65-37a1-4c2a-babb-35d5db592e8d',
      title: 'Test 1',
      courseId: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
    );
  }

  static createTest1() {
    return Test(
      id: 'edf12345-6789-0abc-def1-234567890abc',
      title: 'Test 2',
      courseId: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
    );
  }

  static createNotice() {
    return Notice(
      id: 'basasasas-12345-6789-0abc-def1-234567890abc',
      title: 'Important Update',
      message: 'Please check the latest updates on the course.',
      idCourse: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
    );
  }

  static createNotice1() {
    return Notice(
      id: 'asasasas-12345-6789-0abc-def1-234567890abc',
      title: 'New Assignment',
      message: 'A new assignment has been posted. Please check it out.',
      idCourse: '3a376f1e-7968-4b8f-94b8-08defc1ba40d',
    );
  }

  static createQuestion() {
    return Question(
      id: 'dsf12345-6789-0abc-def1-234567890abc',
      title: 'Que organo pertenece a la junta de andalucia?',
      answers: [
        Answer(text: 'Consejo de Gobierno', isCorrect: true),
        Answer(text: 'Congreso de los Diputados', isCorrect: false),
        Answer(text: 'Senado', isCorrect: false),
        Answer(text: 'Parlamento Europeo', isCorrect: false),
      ],
    );
  }

  static createQuestion1() {
    return Question(
      id: 'q1-12345-6789-0abc-def1-234567890abc',
      title: '¿Cuál es la capital de España?',
      answers: [
        Answer(text: 'Madrid', isCorrect: true),
        Answer(text: 'Barcelona', isCorrect: false),
        Answer(text: 'Valencia', isCorrect: false),
        Answer(text: 'Sevilla', isCorrect: false),
      ],
    );
  }

  static createQuestionInvalid() {
    return Question(
      id: 'invalid-q-12345-6789-0abc-def1-234567890abc',
      title: '¿Cuál es la capital de Francia?',
      answers: [
        Answer(text: 'París', isCorrect: false),
        Answer(text: 'Londres', isCorrect: false),
      ],
    );
  }

  static createQuestionEmptyAnswers() {
    return Question(
      id: 'empty-answers-q-12345-6789-0abc-def1-234567890abc',
      title: '¿Cuál es el océano más grande?',
      answers: [],
    );
  }

  static createUserStudent() {
    return User(
      id: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      name: 'Álvaro',
      surname: 'Gómez',
      email: 'alvaro@gmail.com',
      role: 'student',
    );
  }

  static createUserTeacher() {
    return User(
      id: '61ea020f-5851-48c0-b9b0-6b2680853f7d',
      name: 'Manuel',
      surname: 'Serrano',
      email: 'profe@gmail.com',
      role: 'teacher',
    );
  }
}
