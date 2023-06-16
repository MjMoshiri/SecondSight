package com.android.secondsight.util

import androidx.room.TypeConverter
import com.android.secondsight.data.Interval
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


class TypeConverter {
    private val formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME

    private val gson = Gson()

    @TypeConverter
    fun dataFromString(value: String?): LocalDateTime? {
        return if (value == null) null else LocalDateTime.parse(value, formatter)
    }

    @TypeConverter
    fun dateToString(date: LocalDateTime?): String? {
        return date?.format(formatter)
    }

    @TypeConverter
    fun intervalsFromString(value: String): List<Interval> {
        val listType = object : TypeToken<List<Interval>>() {}.type
        return gson.fromJson(value, listType)
    }

    @TypeConverter
    fun intervalsToString(list: List<Interval>): String {
        return gson.toJson(list)
    }

    @TypeConverter
    fun durationFromString(value: String): Duration {
        return Duration.parse(value)
    }

    @TypeConverter
    fun durationToString(duration: Duration): String {
        return duration.toString()
    }
}