from libqtile.layout.matrix import Matrix


class DynamicMatrix(Matrix):
    def add(self, client):
        ret = super().add(client)
        self.calc_columns()
        return ret

    def remove(self, client):
        ret = super().remove(client)
        self.calc_columns()
        return ret

    def calc_columns(self):
        x = int(len(self.clients) ** 0.5)
        if len(self.clients) > x * (x + 1):
            x += 1
        x = max(1, x)
        if x != self.columns:
            self.columns = x
            self.group.layout_all()
