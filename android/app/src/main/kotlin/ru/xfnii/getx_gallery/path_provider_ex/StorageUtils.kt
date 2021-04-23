package ru.xfnii.getx_gallery.path_provider_ex

import android.content.Context
import android.os.StatFs

class StorageUtils {
    companion object {
        fun getExternalStorageAvailableData(context: Context): ArrayList<HashMap<*, *>> {
            val appsDir = context.getExternalFilesDirs(null)
            val extRootPaths = ArrayList<HashMap<*, *>>()
            for (file in appsDir) {
                val path = file.absolutePath
                val statFs = StatFs(path)
                val availableBytes = statFs.availableBlocksLong * statFs.blockSizeLong
                val storageData = HashMap<String, Any>()
                try {
                    val rootPath = "" //file.getParentFile().getParentFile().getParentFile().getParentFile().getAbsolutePath();
                    storageData["rootPath"] = rootPath
                } catch (e: Exception) {
                }
                storageData["path"] = path
                storageData["availableBytes"] = availableBytes
                extRootPaths.add(storageData)
            }
            return extRootPaths
        }
    }
}