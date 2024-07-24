// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoListAdapter extends TypeAdapter<ToDoList> {
  @override
  final int typeId = 0;

  @override
  ToDoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoList(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      date: fields[3] as DateTime?,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      tasks: (fields[6] as List).cast<Task>(),
    );
  }

  @override
  void write(BinaryWriter writer, ToDoList obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
