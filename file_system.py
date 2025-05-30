import os
import json

class VFSNode:
    def __init__(self, name, flag = False, is_dir=True, children=None):
        self.name = name
        self.is_dir = is_dir
        self.flag = True
        self.children = children or {}

    def to_dict(self):
        return {
            'name': self.name,
            'is_dir': self.is_dir,
            'flag': self.flag,
            'children': {k: v.to_dict() for k, v in self.children.items()}
        }

    @staticmethod
    def from_dict(data):
        node = VFSNode(data['name'], data['is_dir'])
        node.flag = data.get('flag', False)
        node.children = {k: VFSNode.from_dict(v) for k, v in data.get('children', {}).items()}
        return node


class VirtualFileSystem:
    def __init__(self):
        self.root = VFSNode("/")
        self.cwd = []

    def save(self, filename="vfs.json"):
        def reset_flags(node):
            node.flag = False
            for child in node.children.values():
                reset_flags(child)

        reset_flags(self.root)

        with open(filename, "w") as f:
            json.dump(self.root.to_dict(), f)

    def load(self, filename="vfs.json"):
        if os.path.exists(filename):
            with open(filename, "r") as f:
                self.root = VFSNode.from_dict(json.load(f))

    def get_node(self, path=None):
        path = path or self.cwd
        node = self.root
        for part in path:
            node = node.children.get(part)
            if node is None:
                return None
        return node

    def cd(self, path):
        parts = path.strip("/").split("/") if path != "/" else []
        node = self.get_node(parts)
        if node and node.is_dir:
            self.cwd = parts
        else:
            print("Каталог не найден.")

    def dir(self):
        node = self.get_node()
        if node and node.is_dir:
            for child in node.children.values():
                print(f"[{'DIR' if child.is_dir else 'FILE'}] {child.name}")
        else:
            print("Невозможно прочитать каталог.")

    def mount(self, source_path, target_path):
        if not os.path.exists(source_path):
            print("Путь источника не существует.")
            return

        parts = target_path.strip("/").split("/")
        parent_parts = parts[:-1]
        target_name = parts[-1]

        parent = self.get_node(parent_parts)
        if parent is None or not parent.is_dir:
            print("Некорректный путь назначения.")
            return

        def copy_real_fs(src):
            if os.path.isdir(src):
                node = VFSNode(os.path.basename(src), True)
                node.flag = True
                for entry in os.listdir(src):
                    node.children[entry] = copy_real_fs(os.path.join(src, entry))
                return node
            else:
                node = VFSNode(os.path.basename(src), False)
                node.flag = True
                return node

        parent.children[target_name] = copy_real_fs(source_path)

    def umount(self, path):
        parts = path.strip("/").split("/")
        parent_parts = parts[:-1]
        name = parts[-1]
        parent = self.get_node(parent_parts)
        if parent and name in parent.children:
            node_to_remove = parent.children[name]
            if node_to_remove.flag:
                del parent.children[name]
            else:
                print("Нельзя")
        else:
            print("Каталог не найден.")

    def print_help(self):
        print("\nДоступные команды:")
        print("  DIR                      - показать содержимое текущего каталога")
        print("  CD [path]                - перейти в каталог [path]")
        print("  MOUNT [source] [target]  - смонтировать содержимое реальной ФС в VFS")
        print("  UMOUNT [path]            - удалить каталог из VFS")
        print("  HELP                     - показать эту справку")
        print("  QUIT                     - сохранить и выйти\n")

    def run(self):
        while True:
            prompt = "/" + "/".join(self.cwd) + " > "
            cmd = input(prompt).strip()
            if not cmd:
                self.print_help()
                continue

            tokens = cmd.split()
            command = tokens[0].upper()

            if command == "CD":
                if len(tokens) != 2:
                    print("Использование: CD [path]")
                else:
                    self.cd(tokens[1])
            elif command == "DIR":
                self.dir()
            elif command == "MOUNT":
                if len(tokens) != 3:
                    print("Использование: MOUNT [source] [target]")
                else:
                    self.mount(tokens[1], tokens[2])
            elif command == "UMOUNT":
                if len(tokens) != 2:
                    print("Использование: UMOUNT [path]")
                else:
                    self.umount(tokens[1])
            elif command == "HELP":
                self.print_help()
            elif command == "QUIT":
                self.save()
                print("Сохранено. Выход.")
                break
            else:
                print("Неизвестная команда:", command)
                self.print_help()


if __name__ == "__main__":
    vfs = VirtualFileSystem()
    vfs.load()
    vfs.run()
